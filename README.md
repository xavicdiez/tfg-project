# 🚀 Proyecto Final ASIR - Plataforma Kubernetes en GCP con Terraform, Istio y Monitoring

Este proyecto despliega automáticamente una infraestructura en **Google Cloud Platform** utilizando **Terraform**, con:

- Un clúster privado de **GKE (Google Kubernetes Engine)**.
- Configuración de red VPC personalizada con NAT y subredes.
- Instalación automática de **Istio** como malla de servicio.
- Despliegue de **Prometheus** y **Grafana** para observabilidad.
- Control total de la infraestructura como código.

---

## ⚙️ Requisitos previos

- Tener `gcloud` configurado y autenticado.
- Terraform instalado.
- Acceso al proyecto de GCP con permisos suficientes.
- Contexto de Kubernetes configurado.

---

## 🏗️ Acceder al clúster GKE

Primero necesitas obtener las credenciales del clúster para poder usar `kubectl`:

```bash
gcloud container clusters get-credentials NOMBRE_DEL_CLUSTER --zone ZONA --project PROJECT_ID
gcloud container clusters get-credentials cluster-gke --zone europe-west1-b --project project-grupo-10
```

---

## 🔍 Comandos útiles para el clúster

Ver nodos del clúster:

```bash
kubectl get nodes
```

Ver todos los pods en todos los namespaces:

```bash
kubectl get pods -A
```

Ver los servicios de Prometheus y Grafana:

```bash
kubectl get svc -n monitoring
```

Listar los namespaces disponibles:

```bash
kubectl get ns
```

Ver pods y servicios del sistema Istio:

```bash
kubectl get pods -n istio-system
kubectl get svc -n istio-system
```

---

## 🔄 Inyección automática de sidecar (Envoy)

Para que Istio inyecte automáticamente el sidecar en los nuevos pods del namespace `default`, ejecuta:

```bash
kubectl label namespace default istio-injection=enabled
```

📌 Esto aplicará solo a los nuevos pods creados después de aplicar esta etiqueta.

---

## 🧹 Desinstalación de Istio (UNINSTALL)

Si necesitas borrar Istio del clúster, puedes ejecutar los siguientes comandos:

```bash
helm uninstall istio-ingressgateway -n istio-system
helm uninstall istiod -n istio-system
helm uninstall istio-base -n istio-system

kubectl delete crd $(kubectl get crd | grep 'istio.io' | awk '{print $1}')
```
Esto eliminará Istio completamente del clúster, incluyendo sus definiciones de recursos personalizados (CRDs).

## 🧹 Comandos si falla terraform destroy
```bash
terraform state rm data.google_client_config.default
terraform state rm data.google_container_cluster.gke_info
terraform state rm google_project_service.api
terraform state rm kubernetes_namespace.monitoring
```



---

## 📁 Estructura del proyecto (resumen)

```bash
├── apis.tf
├── vpc.tf
├── subnets.tf
├── nat.tf
├── firewalls.tf
├── gke.tf
├── gke-nodes.tf
├── istio.tf
├── monitoring.tf
├── providers.tf
├── locals.tf
```

---

## 👨‍💻 Autores

Javier Cremades Diez

Maria Jesus Cordero Ruiz

Mauricio Vergara Abadal

Proyecto desarrollado como parte del módulo de Proyecto Final de Grado Superior ASIR.  
Despliegue automatizado con Terraform, seguridad reforzada y observabilidad integrada.

---
