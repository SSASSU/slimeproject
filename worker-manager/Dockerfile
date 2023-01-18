# Stage 1 (to create a "build" image, ~140MB)
FROM python:3.7

RUN mkdir /app

RUN apt update
RUN git clone http://192.168.16.40:3000/gitea-admin/worker-manager.git /app
RUN git clone http://192.168.16.40:3000/gitea-admin/kubespray_wmgr.git

RUN pip3 install -r /kubespray_wmgr/requirements.txt

RUN apt install software-properties-common wget -y
RUN apt-add-repository ppa:ansible/ansible -y

RUN ansible-galaxy collection install kubernetes.core
RUN ansible-galaxy collection install community.docker
RUN ansible-galaxy collection install community.libvirt


RUN pip install -r /app/requirements.txt

EXPOSE 8000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000", "--app-dir","/app"]
#ENTRYPOINT ["uvicorn main:app --host 0.0.0.0 --port 8000 --app-dir /app"]


