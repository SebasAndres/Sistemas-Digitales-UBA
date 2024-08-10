from argparse import ArgumentParser

def hex_to_bin(hex_value):
    binary_value = bin(int(hex_value, 16))[2:]
    return binary_value

parser = ArgumentParser(description='Convert hex to binary')
parser.add_argument('hex_value', help='Hex value to convert to binary')
args = parser.parse_args()
res = hex_to_bin(args.hex_value).zfill(32)

print(res)


