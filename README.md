# Slime Project 
이 프로젝트는 K8s환경에서 노드 Autoscaling구현을 목표로 합니다.   


## 🛠️ Environment
- 노드 Provisioning으로 Terraform(libvirt provider)을 사용하고, 생성한 VM노드들로 K8s Cluster 구성(Master 1개, Woker n개)
-  자원부족시 Monitoring측에서 Alert을 API로 받아 노드를 생성과 Cluster Join을 담당하는 Worker Manager(Python)

OS : Rocky 8.7
- go 1.20.3
- Consul v1.16.0
- terraform 1.4.4
- libvirt 8.0.0, qemu 6.2.0
- kubernetes v1.25.6(kubespray release-2.21)

## 📜 Architecture
![as_design](https://cdn.discordapp.com/attachments/1061882461384093786/1064783995369439372/autoscailing_draft.png)

## ⚔️ Challenge
- inventory.ini를 Custom Resource로 관리
- VM생성시 네트워크 정보를 받아 inventory(CR)에 저장
- Worker관리를 담당하는 Manager개발 필요(Python) 
- 클러스터를 Join시킬때 ansible-playbook을 실행할 Container생성(Inventory어떻게 전달할지?)
- CR을 상태를 보고 Worker Manager에게 노드 생성/삭제를 요청하는 Operator작성 필요

<!-- External links -->
