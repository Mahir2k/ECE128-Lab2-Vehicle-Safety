`timescale 1ns / 1ps
`default_nettype none

module tb_vehicle_safety;
    reg  [15:0] sw;
    wire [15:0] led_dataflow, led_behavioral, led_structural;
    integer i;
    integer errors;

    vehicle_safety_dataflow   d0 (.sw(sw), .led(led_dataflow));
    vehicle_safety_behavioral d1 (.sw(sw), .led(led_behavioral));
    vehicle_safety_structural d2 (.sw(sw), .led(led_structural));

    task check_case;
        input [15:0] switches;
        input [15:0] expected;
        begin
            sw = switches;
            #10;
            if ((led_dataflow !== expected) ||
                (led_behavioral !== expected) ||
                (led_structural !== expected)) begin
                $display("FAIL sw=%h expected=%h data=%h beh=%h struct=%h",
                         sw, expected, led_dataflow, led_behavioral, led_structural);
                errors = errors + 1;
            end else begin
                $display("PASS sw=%h led=%h", sw, expected);
            end
        end
    endtask

    initial begin
        errors = 0;
        sw = 0;
        $dumpfile("vehicle_safety.vcd");
        $dumpvars(0, tb_vehicle_safety);

        check_case(16'hFFB8, 16'h8000); // Healthy
        check_case(16'hDFB8, 16'h0000); // Key removed
        check_case(16'h7FB8, 16'h6800); // Driver unbelted
        check_case(16'h7FBC, 16'hE800); // Service mode
        check_case(16'hFDB8, 16'h5080); // Battery fault
        check_case(16'hFFB0, 16'h4000); // Parking brake disengaged
        check_case(16'hFFD8, 16'h6800); // Passenger unbelted
        check_case(16'hFFDC, 16'hE800); // Passenger belt bypass in service
        check_case(16'hFDB8 & 16'hBFFF, 16'h7480); // Battery fault and open door

        // Compare all 16,384 combinations of SW15 through SW2.
        for (i = 0; i < 16384; i = i + 1) begin
            sw = i << 2;
            #1;
            if ((led_dataflow !== led_behavioral) ||
                (led_dataflow !== led_structural)) begin
                $display("MISMATCH sw=%h data=%h beh=%h struct=%h",
                         sw, led_dataflow, led_behavioral, led_structural);
                errors = errors + 1;
            end
        end

        if (errors == 0)
            $display("PASS: directed checks and all 16384 model comparisons");
        else
            $display("FAIL: %0d checks failed", errors);
        $finish;
    end
endmodule

`default_nettype wire
