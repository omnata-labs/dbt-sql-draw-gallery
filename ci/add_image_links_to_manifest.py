import json
data = None
with open('target/manifest.json') as f:
    data = json.load(f)
    for node in data['nodes']:
        print(f"Replacing description in node: {node}")
        this_node = data['nodes'][node]
        data['nodes'][node]['description'] = f"{data['nodes'][node]['description']} ![{data['nodes'][node]['name']}](images/{data['nodes'][node]['name']}.png)"

with open('target/manifest.json', 'w') as f:
    json.dump(data, f)
