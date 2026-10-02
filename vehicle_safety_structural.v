`timescale 1ns / 1ps
`default_nettype none

module vehicle_safety_structural (
    input  wire [15:0] sw,
    output wire [15:0] led
);
    wire n_sb, n_door, n_hood, n_trunk, n_bat, n_airbag, n_temp;
    wire n_pass_belt, n_pass_occ, n_pbrk;
    wire seat_warn, door_warn, hood_warn, trunk_warn;
    wire bat_warn, airbag_warn, temp_warn;
    wire warn_pri1, warn_pri2, pass_unbelted;
    wire pass_clear, belt_ok, base_ok, service_or_belts;
    wire start_permit, chime, any_chime;

    not (n_sb, sw[15]);
    not (n_door, sw[14]);
    not (n_hood, sw[10]);
    not (n_trunk, sw[4]);
    not (n_bat, sw[9]);
    not (n_airbag, sw[8]);
    not (n_temp, sw[7]);
    not (n_pass_belt, sw[5]);
    not (n_pass_occ, sw[6]);
    not (n_pbrk, sw[3]);

    and (pass_unbelted, sw[6], n_pass_belt);
    or  (seat_warn, n_sb, pass_unbelted);
    buf (door_warn, n_door);
    buf (hood_warn, n_hood);
    buf (trunk_warn, n_trunk);
    buf (bat_warn, n_bat);
    buf (airbag_warn, n_airbag);
    buf (temp_warn, n_temp);

    or (warn_pri1, hood_warn, bat_warn, airbag_warn, temp_warn);
    or (warn_pri2, seat_warn, door_warn, trunk_warn);
    or (pass_clear, n_pass_occ, sw[5]);
    and (belt_ok, sw[15], pass_clear);
    and (base_ok, sw[13], sw[12], sw[11], sw[3], sw[14],
         sw[10], sw[4], sw[9], sw[8], sw[7]);
    or  (service_or_belts, sw[2], belt_ok);
    and (start_permit, base_ok, service_or_belts);
    or  (any_chime, warn_pri1, warn_pri2, n_pbrk);
    and (chime, sw[13], any_chime);

    buf (led[15], start_permit);
    buf (led[14], chime);
    buf (led[13], warn_pri2);
    buf (led[12], warn_pri1);
    buf (led[11], seat_warn);
    buf (led[10], door_warn);
    buf (led[9], hood_warn);
    buf (led[8], trunk_warn);
    buf (led[7], bat_warn);
    buf (led[6], airbag_warn);
    buf (led[5], temp_warn);
    assign led[4:0] = 5'b00000;
endmodule

`default_nettype wire
