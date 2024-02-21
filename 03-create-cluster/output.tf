
resource "null_resource" "delegate" {
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<EOT
       val=$(az aro list-credentials --name $CL --resource-group $RG )
       api=$(az aro show -g $RG -n $CL --query apiserverProfile.url -o tsv)
       consoleurl=$(az aro show --name $CL --resource-group $RG --query "consoleProfile.url" -o tsv)
       username=$(echo $val | jq -r ".kubeadminUsername")
       password=$(echo $val | jq -r ".kubeadminPassword")
       echo "oc login -u $username -p $password $api" > /opt/homebrew/bin/aro-login
       echo "open -a 'Google Chrome.app' $consoleurl" > /opt/homebrew/bin/open-aro
       echo "echo Username: $username" > /opt/homebrew/bin/aro-creds
       echo "echo Password: $password" >> /opt/homebrew/bin/aro-creds
       chmod +x /opt/homebrew/bin/aro-login
       chmod +x /opt/homebrew/bin/aro-creds
       chmod +x /opt/homebrew/bin/open-aro
    EOT
     environment = {
        RG = var.resource_group_name
        CL = var.cluster_name
  }
  }
  depends_on = [ azurerm_redhat_openshift_cluster.cluster_from_akv ] 
}