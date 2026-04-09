import json

with open("coverage.json") as f:
    data = json.load(f)

coverage = data["totals"]["percent_covered"]

print(f"Coverage: {coverage}%")

if coverage < 70:
    print("❌ Coverage abaixo do mínimo")
    exit(1)
else:
    print("✅ Coverage OK")