#!/usr/bin/env python3
"""Compare retained original outcomes without changing suite verdicts."""
import json
import os
from pathlib import Path
import re
import sys

root = Path(__file__).resolve().parent.parent
expected = json.loads((root / 'script/baseline-green-expected.json').read_text())
evidence = Path(os.environ['RUNNER_TEMP']) / 'umbrella-validation'
errors = []
result = {'baseline_run': expected['run'], 'lane': sys.argv[1]}
if sys.argv[1] == 'bash53':
    platform = {'Linux': 'ubuntu-latest', 'macOS': 'macos-latest', 'Windows': 'windows-latest'}[os.environ['RUNNER_OS']]
    log = root / 'bashy/bash53-windows.log' if platform == 'windows-latest' else evidence / 'bash53-native.log'
    rows = re.findall(r'^\s*(PASS|FAIL|SKIP|TIME)\s+(\S+)\s*$', log.read_text(errors='replace') if log.exists() else '', re.M)
    actual = {name: status for status, name in rows}
    baseline = expected['bash53'][platform]
    if len(rows) != len(actual) or set(actual) != set(baseline):
        errors.append('Missing, duplicate, or additional case identities')
    for name, status in baseline.items():
        if status == 'PASS' and actual.get(name) != 'PASS':
            errors.append(f'Previously PASS {name}: {actual.get(name, "MISSING")}')
        elif status != 'PASS' and actual.get(name) not in (status, 'PASS'):
            errors.append(f'Baseline {name}={status} changed to {actual.get(name, "MISSING")}')
    result.update(platform=platform, cases=actual)
elif sys.argv[1] == 'module-tests':
    mode = os.environ['DEPENDENCY_MODE']
    path = evidence / 'exit-codes.tsv'
    rows = [line.split('\t') for line in path.read_text().splitlines()] if path.exists() else []
    actual = {name: int(code) for name, code in rows}
    baseline = expected['module_stages'][mode]
    if len(rows) != len(actual) or set(actual) != set(baseline):
        errors.append('Missing, duplicate, or additional module stages')
    for name, code in baseline.items():
        if code == 0 and actual.get(name) != 0:
            errors.append(f'Previously green stage {name}: {actual.get(name, "MISSING")}')
    result.update(mode=mode, stages=actual, limitation='Original nonverbose results do not enumerate individual PASS/SKIP identities; no test-level pass-set inference.')
else:
    raise SystemExit('unsupported lane')
result['errors'] = errors
evidence.mkdir(parents=True, exist_ok=True)
(evidence / 'baseline-green-comparison.json').write_text(json.dumps(result, indent=2) + '\n')
print(json.dumps(result, indent=2))
raise SystemExit(bool(errors))
