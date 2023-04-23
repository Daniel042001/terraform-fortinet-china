## HOWTO DEPLOY
1.  MODIFY `terraform.tfvars` to fit your provisioning.
2.  FOLLOW `terraform` init-plan-apply procedure described in upper folders.
3.  CHECK `terraform output` whether there is any errors.
4.  ACCESS FortiGate using `terraform output` parameters.

## Standalone FortiGate Topology
### All-In-One VPC Solution WITHOUT bastion host
![Image Text](https://github.com/Daniel042001/terraform-fortinet-china/blob/main/terraform-awschina/fgtvm-gwlb-with-fwb/fgtvm-gwlb-with-fwb-without-bastion.png)

### All-In-One VPC Solution WITH bastion host
![Image Text](https://github.com/Daniel042001/terraform-fortinet-china/blob/main/terraform-awschina/fgtvm-gwlb-with-fwb/fgtvm-gwlb-with-fwb-with-bastion.png)

