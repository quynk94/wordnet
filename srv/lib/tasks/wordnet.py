from nltk.corpus import wordnet as wn
import sys
import json

def main():
  word = sys.argv[1]
  lexname = sys.argv[2]

  synsets = wn.synsets(word)

  synsets = [item for item in synsets if item.name().split('.')[0] == word and item.name().split('.')[1] == 'n' and item.lexname() == lexname]
  if len(synsets) > 0:
    hypernym_paths = synsets[0].hypernym_paths()
    hypernum_paths_name = list(map(lambda x: list(map(lambda y: y.name(), x)), hypernym_paths))

    print(json.dumps(hypernum_paths_name))
  else:
    print(json.dumps([]))

main()
