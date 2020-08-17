## Requirements

The following requirements are needed by this module:

- terraform (>=0.12)

- local (>=1.4.0)

- null (>=2.1.2)

- openstack (>=1.24.0)

- rke (>=1.0.0)

## Required Inputs

The following input variables are required:

### public\_net\_name

Description: External network name

Type: `string`

### image\_name

Description: Name of image nodes (must fullfill RKE requirements)

Type: `string`

### master\_flavor\_name

Description: Master flavor name

Type: `string`

### worker\_flavor\_name

Description: Worker flavor name

Type: `string`

### os\_auth\_url

Description: Openstack auth\_url. Consider using export TF\_VAR\_os\_auth\_url=$OS\_AUTH\_URL

Type: `string`

### os\_password

Description: Openstack password. Consider using export TF\_VAR\_os\_password=$OS\_PASSWORD

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### cluster\_name

Description: Name of the cluster

Type: `string`

Default: `"rke"`

### ssh\_keypair\_name

Description: SSH keypair name

Type: `string`

Default: `null`

### ssh\_key\_file

Description: Local path to SSH key

Type: `string`

Default: `"~/.ssh/id_rsa"`

### secgroup\_rules

Description: Security group rules

Type: `list`

Default:

```json
[
  {
    "port": 22,
    "protocol": "tcp",
    "source": "0.0.0.0/0"
  },
  {
    "port": 6443,
    "protocol": "tcp",
    "source": "0.0.0.0/0"
  },
  {
    "port": 80,
    "protocol": "tcp",
    "source": "0.0.0.0/0"
  },
  {
    "port": 443,
    "protocol": "tcp",
    "source": "0.0.0.0/0"
  }
]
```

### nodes\_net\_cidr

Description: Neutron network CIDR

Type: `string`

Default: `"192.168.42.0/24"`

### dns\_servers

Description: DNS servers

Type: `list(string)`

Default: `null`

### dns\_domain

Description: DNS domain for DNS integration. DNS domain names must have a dot at the end

Type: `string`

Default: `null`

### master\_count

Description: Number of master nodes (should be odd number...)

Type: `number`

Default: `1`

### edge\_count

Description: Number of edge nodes

Type: `number`

Default: `0`

### worker\_count

Description: Number of woker nodes

Type: `number`

Default: `2`

### edge\_flavor\_name

Description: Edge flavor name. Will use worker\_flavor\_name if not set

Type: `string`

Default: `null`

### master\_server\_affinity

Description: Master server group affinity

Type: `string`

Default: `"soft-anti-affinity"`

### worker\_server\_affinity

Description: Worker server group affinity

Type: `string`

Default: `"soft-anti-affinity"`

### edge\_server\_affinity

Description: Edge server group affinity

Type: `string`

Default: `"soft-anti-affinity"`

### nodes\_config\_drive

Description: Whether to use the config\_drive feature to configure the instances

Type: `bool`

Default: `"false"`

### user\_data\_file

Description: User data file to provide when launching the instance

Type: `string`

Default: `null`

### system\_user

Description: Default OS image user

Type: `string`

Default: `"ubuntu"`

### use\_ssh\_agent

Description: Whether to use ssh agent

Type: `bool`

Default: `"true"`

### bastion\_host

Description: Bastion host. Will use first master node if not set

Type: `string`

Default: `null`

### wait\_for\_commands

Description: Commands to run on nodes before running RKE

Type: `list(string)`

Default:

```json
[
  "# Connected !"
]
```

### master\_labels

Description: Master labels. Ingress controller will run on nodes with egde label

Type: `map(string)`

Default:

```json
{
  "node-role.kubernetes.io/edge": "true",
  "node-role.kubernetes.io/master": "true"
}
```

### worker\_labels

Description: Worker labels

Type: `map(string)`

Default:

```json
{
  "node-role.kubernetes.io/worker": "true"
}
```

### edge\_labels

Description: Edge labels. Ingress controller will run on nodes with egde label

Type: `map(string)`

Default:

```json
{
  "node-role.kubernetes.io/worker": "true"
}
```

### kubernetes\_version

Description: Kubernetes version (RKE)

Type: `string`

Default: `null`

### cni\_mtu

Description: CNI MTU

Type: `number`

Default: `0`

### cloud\_provider

Description: Deploy cloud provider

Type: `bool`

Default: `"true"`

### deploy\_traefik

Description: Whether to deploy traefik. Mandatory if no edge nodes

Type: `bool`

Default: `"true"`

### traefik\_image\_tag

Description: Traefik version

Type: `string`

Default: `"2.2"`

### deploy\_nginx

Description: Whether to deploy nginx RKE addon

Type: `bool`

Default: `"false"`

### acme\_email

Description: Email for Let's Encrypt

Type: `string`

Default: `"example@example.com"`

### storage\_types

Description: Cinder storage types

Type: `list(string)`

Default: `null`

### default\_storage

Description: Default storage class

Type: `string`

Default: `null`

### addons\_include

Description: RKE YAML files for add-ons

Type: `list(string)`

Default: `null`

### write\_kubeconfig

Description: Write kubeconfig file to disk

Type: `bool`

Default: `"true"`

## Outputs

The following outputs are exported:

### keypair\_name

Description: The name of the keypair used for nodes

### master\_nodes

Description: The master nodes

### edge\_nodes

Description: The edge nodes

### worker\_nodes

Description: The worker nodes

### rke\_cluster

Description: RKE cluster spec
