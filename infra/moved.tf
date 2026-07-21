# moved.tf — migração suave Fase 1 → Fase 2 (evita destroy desnecessário da 1ª subnet).
# Se o state ainda tiver aws_subnet.public / associação antiga, o Terraform renomeia.

moved {
  from = aws_subnet.public
  to   = aws_subnet.public_a
}

moved {
  from = aws_route_table_association.public
  to   = aws_route_table_association.public_a
}
