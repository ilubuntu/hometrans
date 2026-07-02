import json, sys
def walk(node, depth=0, out=None):
    if out is None: out=[]
    a = node.get('attributes', {})
    t = a.get('text','')
    cd = a.get('description','') or a.get('content-desc','')
    b = a.get('bounds','')
    type_ = node.get('type','') or a.get('type','')
    label = t or cd or a.get('value','')
    if label or b:
        out.append(f"{type_} | {label!r} | bounds={b}")
    for c in node.get('children', []) or []:
        walk(c, depth+1, out)
    return out
d = json.load(open(sys.argv[1]))
for line in walk(d):
    # filter to elements with text/desc and bounds
    if "''" not in line.split('|')[1] or 'bounds=[[' in line:
        print(line)
