# ---------------------------------------------------------------------
# Route Table
# ---------------------------------------------------------------------
resource "aws_route_table" "TerraFailRoute_table" {
  # Drata: Configure [aws_route_table.tags] to ensure that organization-wide tagging conventions are followed.
  vpc_id = aws_vpc.TerraFailRoute_vpc.id
  route  = []
}

# ---------------------------------------------------------------------
# Network
# ---------------------------------------------------------------------
resource "aws_vpc" "TerraFailRoute_vpc" {
  # Drata: Configure [aws_vpc.tags] to ensure that organization-wide tagging conventions are followed.
  cidr_block = "10.0.0.0/16"
}
