module sm #(parameter COUNTER_WIDTH = 4)(clk,rst_n,act,up_dwn_n,count,ovflw);
  
  
  input clk;
  input rst_n;
  input act;
  input up_dwn_n;
  output [COUNTER_WIDTH-1:0] count;
  output ovflw;  
  // Internal registers
  reg [COUNTER_WIDTH-1:0] count;
  wire ovflw;
  reg [3:0] state, next_state;

  // State encoding
  localparam IDLE  = 4'b0001;
  localparam CNTUP = 4'b0010;
  localparam CNTDN = 4'b0100;
  localparam OVFLW = 4'b1000;

  //==============================
  // Combinational Block: Next State Logic
  //==============================
  always @* begin
    case (state)
      IDLE: begin
        if (act)
          if (up_dwn_n)
            next_state = CNTUP;
          else
            next_state = CNTDN;
        else
          next_state = IDLE;
      end

      CNTUP: begin
        if (act)
          if (up_dwn_n)
            if (count == (1<<COUNTER_WIDTH)-1)
              next_state = OVFLW;
            else
              next_state = CNTUP;
          else
            if (count == 'b0)
              next_state = OVFLW;
            else
              next_state = CNTDN;
        else
          next_state = IDLE;
      end

      CNTDN: begin
        if (act)
          if (up_dwn_n)
            if (count == (1<<COUNTER_WIDTH)-1)
              next_state = OVFLW;
            else
              next_state = CNTUP;
          else
            if (count == 'b0)
              next_state = OVFLW;
            else
              next_state = CNTDN;
        else
          next_state = IDLE;
      end

      OVFLW: begin
        next_state = OVFLW;
      end

      default: begin
        next_state = 'bx;
        $display("%t: State machine not initialized\n", $time);
      end
    endcase
  end

  //==============================
  // Sequential Block: State Registers
  //==============================
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      state <= IDLE;
    else
      state <= next_state;
  end

  //==============================
  // Sequential Block: Counter Logic
  //==============================
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      count <= 'b0;
    else if (state == CNTUP)
      count <= count + 1'b1;
    else if (state == CNTDN)
      count <= count - 1'b1;
  end

  //==============================
  // Output Assignment (Moore FSM)
  //==============================
  assign ovflw = (state == OVFLW) ? 1'b1 : 1'b0;

endmodule
