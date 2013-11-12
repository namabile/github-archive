import sys
import json

if __name__ == "__main__":
    with open(sys.argv[1], "r") as f:
        for line in f:
            data = json.loads(line)
            print json.dumps(data, indent=4, sort_keys=True)
