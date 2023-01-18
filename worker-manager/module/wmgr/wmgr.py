from ansible import context
from ansible.cli import CLI
from ansible.module_utils.common.collections import ImmutableDict
from ansible.executor.playbook_executor import PlaybookExecutor
from ansible.parsing.dataloader import DataLoader
from ansible.inventory.manager import InventoryManager
from ansible.vars.manager import VariableManager
from fastapi import FastAPI, APIRouter

import asyncio

#global status var. --> Not Thread Safe!!!!!!!!!!!
#0 : stop
#1 : something running...


class Worker():

    def __init__(self):
 
        self.running_status=0
        self.loader = DataLoader()
        #ansible run flag 
        context.CLIARGS = ImmutableDict(tags={}, listtags=False, listtasks=False, listhosts=False, syntax=False, connection='ssh',
                    module_path=None, forks=100, remote_user='root', private_key_file=None,
                    ssh_common_args=None, ssh_extra_args=None, sftp_extra_args=None, scp_extra_args=None, become=True,
                    become_method='sudo', become_user='root', verbosity=True, check=False, start_at_task=None) 

        self.inventory = InventoryManager(loader=self.loader, sources=("./kubespray/inventory/my-cluster/inventory.ini"))
        self.variable_manager = VariableManager(loader=self.loader, inventory=self.inventory, version_info=CLI.version_info(gitinfo=False))

 
        self.router = APIRouter()
        self.router.add_api_route("/worker/list", self.list, methods=["GET"])
        self.router.add_api_route("/worker/add",  self.add, methods=["POST"])
        self.router.add_api_route("/worker/remove",  self.remove, methods=["DELETE"])
 
    async def list(self):

        return {"Worker list - Not Working...."}

   
    async def add(self):

        if 1 == self.running_status:
            return {"[Worker add] task running...."}
        
        self.running_status=1
        self.inventory.subset('worker3')
        pbex = PlaybookExecutor(playbooks=['./kubespray/scale.yml'], inventory=self.inventory, variable_manager=self.variable_manager, loader=self.loader, passwords={})
        results = pbex.run()

        self.running_status=0        

        return {"status : (Not Impl)"}

    async def remove(self):

        self.variable_manager.extra_vars['node']='worker3'
        pbex = PlaybookExecutor(playbooks=['./kubespray/remove-node.yml'], inventory=self.inventory, variable_manager=self.variable_manager, loader=self.loader, passwords={})
        
        print (self.variable_manager.extra_vars)
        results = pbex.run()
        return {"status : (Not Impl)"}

   
