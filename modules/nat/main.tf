# ─── Elastic IP for NAT Gateway ──────────────────────────────────────────────
# NAT Gateway needs a static public IP address
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name        = "${var.project_name}-${var.environment}-nat-eip"
    Environment = var.environment
  }
}

# ─── NAT Gateway ─────────────────────────────────────────────────────────────
# Sits in public subnet, allows private subnet resources to reach internet
# Private resources (RDS, app servers) can download patches/updates
# But nothing from internet can initiate a connection to private resources
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = var.public_subnet_id

  tags = {
    Name        = "${var.project_name}-${var.environment}-nat"
    Environment = var.environment
  }
}

# ─── Private Route Table ──────────────────────────────────────────────────────
# Routes outbound traffic from private subnets through NAT Gateway
resource "aws_route_table" "private" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-private-rt"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_ids)
  subnet_id      = var.private_subnet_ids[count.index]
  route_table_id = aws_route_table.private.id
}
