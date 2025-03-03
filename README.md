# End-to-End Secure CI/CD Pipeline with DevSecOps on the MERN Stack
---

🚀 **This project demonstrates an End-to-End DevSecOps pipeline leveraging the MERN Stack (React, Redux Toolkit, Tailwind, MongoDB) with a focus on security, code quality, and continuous deployment using AWS, Kubernetes, Jenkins, and other robust tools.**

## 📽️ Demo Video
![Ecommerce-presentation](https://github.com/Subhabrata2468/Ecommerce-project-2/blob/master/Ecommerce-presentation.gif)

## 🌟 Key Highlights

1. **AWS Cloud:** ☁️ Using EC2 instances and EKS for Kubernetes orchestration.
2. **CI/CD Pipeline:** ⚙️ Powered by Jenkins for continuous delivery and NPM for dependency management.
3. **Security-first Approach:** 🔐
   - Trivy for Docker image vulnerability scanning.
   - OWASP Dependency Check for identifying security risks in dependencies.
4. **Code Quality Assurance:** 🧪
   - SonarQube for code quality and security checks.
5. **Kubernetes Deployment:** 🚢
   - Automated via Helm and Docker for managing and pushing images.
6. **Monitoring and Visualization:** 📈
   - Prometheus for real-time metrics collection.
   - Grafana for creating insightful monitoring dashboards.

## 🔧 Tools & Technologies Used

- **MERN Stack:** MongoDB, Express, React, Node.js
- **CI/CD:** Jenkins, GitLab CI
- **Containerization:** Docker, Docker Compose
- **Cloud Infrastructure:** AWS EC2, EKS
- **Security:** Trivy, OWASP Dependency Check
- **Code Quality:** SonarQube
- **Orchestration:** Kubernetes, Helm
- **Monitoring:** Prometheus, Grafana
- **Version Control:** Git
- **Package Management:** NPM

## 🚀 Deployment Instructions

### 1. Using Docker Compose
```bash
docker-compose up --build
