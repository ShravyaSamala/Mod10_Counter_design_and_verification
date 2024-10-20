
class count_trans;
     
rand bit[3:0] data_in;
rand bit mode;
rand bit load;
rand bit reset;
logic [3:0] data_out;

static int trans_id;


   
constraint VALID_LOAD {load dist{0:=100, 1:=10};}
constraint VALID_MODE {mode dist{0:=50,1:=50};}
constraint VALID_DATA {data_in inside {[1:9]};}
constraint VALID_RESET {reset dist {0:=300, 1:=10};}
 
function void post_randomize();
      this.display("\tRANDOMIZED DATA");
endfunction: post_randomize

      virtual function void display(input string message);
      $display("=============================================================");
      $display("%s",message);
      if(message=="\tRANDOMIZED DATA")
         begin
            $display("\t_______________________________");
            $display("\tTransaction No. %d",trans_id);
            $display("\t_______________________________");
         end
      $display("\treset=%d, load=%d, mode=%0d",reset,load,mode);
      $display("\tdata_in=%0d",data_in);
      $display("\tData_out= %d",data_out);
      $display("=============================================================");
   endfunction: display



endclass: count_trans
