function[Ruv1, Vhys] = calc_uvlo_res(Vin_uv, Ruv2, Ven_op, Ien_stby, Delta_Ihys_op);
Vhys = Delta_Ihys_op.* Ruv2;
Ruv1 = (Ruv2 .* Ven_op)./ (Vin_uv+ (Ien_stby.*Ruv2)- Ven_op);