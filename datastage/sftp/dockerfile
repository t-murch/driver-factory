# Datastage uses RHEL as base. Using Centos here for convenience. Should be compatible but may want to modify
FROM centos:7

# Can be altered to whatever tools are needed
RUN yum -y install openssh which openssh-clients

# chmod 777 is bad practice, need to change this.
RUN mkdir /sftp && chmod 777 /sftp

#exportbin.sh will take all library dependencies of any binary and add them to a folder
ADD exportbin.sh .
RUN chmod +x exportbin.sh && ./exportbin.sh $(which sftp) /sftp
RUN ./exportbin.sh $(which ssh) /sftp


USER 1001

#Copy over files and then run forever. This is for sidecar pattern but probably better as a Job
CMD cp -R /sftp/. /destination && tail -f /dev/null
