#!/usr/bin/python
import sys, json

expername = sys.argv[1]

with open('config.json', 'r+') as f:
    data = json.load(f)
    data['experiment-name'] = expername # <--- add `id` value.
    f.seek(0)        # <--- should reset file position to the beginning.
    json.dump(data, f, indent=4)
    f.truncate()     # remove remaining part

# with open('config.json', 'r') as f:
#     json_data = json.load(f)
#     json_data['experiment-name'] = expername

# with open('config.json', 'w') as f:
#     f.write(json.dumps(json_data))