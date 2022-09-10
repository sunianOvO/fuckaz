import io
import json
import time
import random
from contextlib import redirect_stdout
from azure.cli.core import get_default_cli

locations = ['koreasouth']

vm_size = "Standard_E2bds_v5"
size_count = 5
fuck = random.randint(0,9999999999)

get_default_cli().invoke(['group', 'create', '--name', 'ResourceGroup',
                          '--location', 'eastasia'])
print("Resource Group Created Successfully")
for location in locations: 
    count = 0
    for a in range(0, size_count):
        count += 1
        print(str(count) + " of " + str(size_count) + " " + str(vm_size) + " VM in " + str(location) + " is being Created")
        get_default_cli().invoke(
            ['vm', 'create', '--resource-group', 'ResourceGroup', '--name',
             f'{location}-{vm_size}-{count}-{fuck}', '--image', 'UbuntuLTS',
             '--size', f'{vm_size}', '--location', f'{location}', '--admin-username',
             'axuan', '--admin-password', '320Hanyue1827...', '--custom-data',
             '/.XX/cloud-init.txt', "--no-wait"])

print("\n")
print("VM Created Successfully")
print("\n")
print("VM List: ")
get_default_cli().invoke(['vm', 'list', '--query', '[*].name'])
print("\n")
