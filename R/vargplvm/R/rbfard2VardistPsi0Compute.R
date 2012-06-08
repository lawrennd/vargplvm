rbfard2VardistPsi0Compute <-
function (rbfardKern, vardist)
{
# % RBFARD2VARDISTPSI0COMPUTE description.
#   
# % VARGPLVM
#   
# % variational means

k0 <- vardist$numData*rbfardKern$variance

return (k0)
}
