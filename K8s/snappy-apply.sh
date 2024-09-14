#!/bin/bash


#kubectl create namespace shopping

#kubectl delete pods,services,deployments,horizontalpodautoscaler --all -n shopping 

# Apply MongoDB deployment and service
kubectl apply -f persistentVolumeClaim.yml
kubectl apply -f storageClass-for-mongos.yml
kubectl apply -f mongo-deployment.yml
kubectl apply -f mongo-service.yml
kubectl apply -f hpa-mongo.yml

# Apply Backend deployment and service
kubectl apply -f backend-deployment.yml
kubectl apply -f backend-service.yml
kubectl apply -f hpa-backend.yml

# Apply Frontend deployment and service
kubectl apply -f frontend-deployment.yml
kubectl apply -f frontend-service.yml
kubectl apply -f hpa-frontend.yml


#kubectl apply -f default-backend.yml
#kubectl apply -f ingress.yml
echo "All Kubernetes resources have been applied."
