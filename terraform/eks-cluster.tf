module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.21.0"

  cluster_name = "sock-shop-cluster"  
  cluster_version = "1.29"

  subnet_ids = module.sock-shop-vpc.private_subnets
  vpc_id = module.sock-shop-vpc.vpc_id

  tags = {
    environment = "development"
    application = "sock-shop-app"
  }

  eks_managed_node_groups = {
    dev = {
      min_size     = 1
      max_size     = 3
      desired_size = 3

      instance_types = ["t2.small"]
    }
  }
}


