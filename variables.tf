
variable "project" {
    type        = string
    description = "The project id."
    default     = "test-project-id"
}

variable "environment" {
    type        = string
    description = "The environment."
    default     = "staging"
}

variable "cluster_name" {
    type        = string
    description = "The name of the cluster."
    default     = "staging"
}

variable "node_locations" {
    type = list(string)
    description = "List of availablity zones that the nodes should be created."
    default = [
        "europe-west3-a",
        "europe-west3-b"
    ]
}

variable "region" {
    type        = string
    description = "The region of the cluster."
    default     = "europe-west3"
}

variable "zone" {
    type        = string
    description = "The zone of the cluster."
    default     = "europe-west3-a"
}

variable "master_node_username" {
    type        = string
    description = "The username to be used with basic authentication. If left empty basic authentication is disabled."
    default     = ""
}

variable "master_node_password" {
    type        = string
    description = "The password to be used with basic authentication. If left empty basic authentication is disabled."
    default     = ""
}

variable "initial_node_count" {
    type        = number
    description = "The initial count of nodes for the cluster."
    default     = 1
}

variable "node_count" {
    type        = number
    description = "The actual count of nodes in the cluster."
    default     = 1
}

variable "min_node_count" {
    type        = number
    description = "The minimum count of nodes in the cluster. (autoscaling)"
    default     = 1
}

variable "max_node_count" {
    type        = number
    description = "The max count of nodes in the cluster. (autoscaling)"
    default     = 5
}
