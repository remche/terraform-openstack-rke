## Requirements

| Name | Version |
|------|---------|
| terraform | >=0.12 |
| local | >=1.4.0 |
| null | >=2.1.2 |
| openstack | >=1.24.0 |
| rke | >=1.0.0 |

## Providers

No provider.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| acme\_email | Email for Let's Encrypt | `string` | `"example@example.com"` | no |
| addons\_include | RKE YAML files for add-ons | `list(string)` | `null` | no |
| bastion\_host | Bastion host. Will use first master node if not set | `string` | `null` | no |
| cloud\_provider | Deploy cloud provider | `bool` | `"true"` | no |
| cluster\_name | Name of the cluster | `string` | `"rke"` | no |
| cni\_mtu | CNI MTU | `number` | `0` | no |
| default\_storage | Default storage class | `string` | `null` | no |
| deploy\_nginx | Whether to deploy nginx RKE addon | `bool` | `"false"` | no |
| deploy\_traefik | Whether to deploy traefik. Mandatory if no edge nodes | `bool` | `"true"` | no |
| dns\_servers | DNS servers | `list(string)` | `null` | no |
| edge\_count | Number of edge nodes | `number` | `0` | no |
| edge\_flavor\_name | Edge flavor name. Will use worker\_flavor\_name if not set | `string` | `null` | no |
| edge\_labels | Edge labels. Ingress controller will run on nodes with egde label | `map(string)` | <pre>{<br>  "node-role.kubernetes.io/worker": "true"<br>}</pre> | no |
| edge\_server\_affinity | Edge server group affinity | `string` | `"soft-anti-affinity"` | no |
| image\_name | Name of image nodes (must fullfill RKE requirements) | `string` | n/a | yes |
| kubernetes\_version | Kubernetes version (RKE) | `string` | `null` | no |
| master\_count | Number of master nodes (should be odd number...) | `number` | `1` | no |
| master\_flavor\_name | Master flavor name | `string` | n/a | yes |
| master\_labels | Master labels. Ingress controller will run on nodes with egde label | `map(string)` | <pre>{<br>  "node-role.kubernetes.io/edge": "true",<br>  "node-role.kubernetes.io/master": "true"<br>}</pre> | no |
| master\_server\_affinity | Master server group affinity | `string` | `"soft-anti-affinity"` | no |
| nodes\_config\_drive | Whether to use the config\_drive feature to configure the instances | `bool` | `"false"` | no |
| nodes\_net\_cidr | Neutron network CIDR | `string` | `"192.168.42.0/24"` | no |
| os\_auth\_url | Openstack auth\_url. Consider using export TF\_VAR\_os\_auth\_url=$OS\_AUTH\_URL | `string` | n/a | yes |
| os\_password | Openstack password. Consider using export TF\_VAR\_os\_password=$OS\_PASSWORD | `string` | n/a | yes |
| public\_net\_name | External network name | `string` | n/a | yes |
| secgroup\_rules | Security group rules | `list` | <pre>[<br>  {<br>    "port": 22,<br>    "protocol": "tcp",<br>    "source": "0.0.0.0/0"<br>  },<br>  {<br>    "port": 6443,<br>    "protocol": "tcp",<br>    "source": "0.0.0.0/0"<br>  },<br>  {<br>    "port": 80,<br>    "protocol": "tcp",<br>    "source": "0.0.0.0/0"<br>  },<br>  {<br>    "port": 443,<br>    "protocol": "tcp",<br>    "source": "0.0.0.0/0"<br>  }<br>]</pre> | no |
| ssh\_key\_file | Local path to SSH key | `string` | `"~/.ssh/id_rsa"` | no |
| ssh\_keypair\_name | SSH keypair name | `string` | `null` | no |
| storage\_types | Cinder storage types | `list(string)` | `null` | no |
| system\_user | Default OS image user | `string` | `"ubuntu"` | no |
| traefik\_image\_tag | Traefik version | `string` | `"2.2"` | no |
| use\_ssh\_agent | Whether to use ssh agent | `bool` | `"true"` | no |
| user\_data\_file | User data file to provide when launching the instance | `string` | `null` | no |
| worker\_count | Number of woker nodes | `number` | `2` | no |
| worker\_flavor\_name | Worker flavor name | `string` | n/a | yes |
| worker\_labels | Worker labels | `map(string)` | <pre>{<br>  "node-role.kubernetes.io/worker": "true"<br>}</pre> | no |
| worker\_server\_affinity | Worker server group affinity | `string` | `"soft-anti-affinity"` | no |
| write\_kubeconfig | Write kubeconfig file to disk | `bool` | `"true"` | no |

## Outputs

| Name | Description |
|------|-------------|
| edge\_nodes | The edge nodes |
| keypair\_name | The name of the keypair used for nodes |
| master\_nodes | The master nodes |
| rke\_cluster | RKE cluster spec |
| worker\_nodes | The worker nodes |
