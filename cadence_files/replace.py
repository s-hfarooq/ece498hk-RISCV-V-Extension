import numpy as np



def replace_transistors(files):
    for file in files:
        netlist_file = open("lvs/"+file,"r")
        lines = netlist_file.readlines()
        out_file = []
        subcircuit = ""
        intance_name = ""
        for i,line in enumerate(lines):
            if ".SUBCKT" in line:
                subcircuit = line.split(' ')[1]
            if "+" not in line:
                instance_name = line.split(' ')[0]
            if "Xclk_gate_imd_val_q_reg_1_" in line:
                out_file.append("* "+line)
                continue
            if "+ SNPS_CLOCK_GATE_HIGH_ibex_id_stage_0_0_0_0_1_0_1_0" in line:
                out_file.append("* "+line)
                continue
            # if instance_name == "Xdata_memory":
            #     x = line.split(' ')
            #     for j,value in enumerate(x):
            #         if "_NeTt_186" in value:
            #             x[j] = "vdd"
            #         if "_NeTt_187" in value:
            #             x[j] = "vdd\n"
            #         if "_NeTt_188" in value:
            #             x[j] = "vss"
            #     out = ' '.join(x)
            #     out_file.append(out)
            #     print(out)
            #     continue
            if "nch_lvt" in line:
                x = line.split(' ')
                for j,value in enumerate(x):
                    if "nch_l" in value:
                        x[j] = "NCHPD_SR"
                    if "w=" in value:
                        x[j] = "w=1.4E-07"
                out = ' '.join(x)
                out_file.append(out)
                print(out)
                continue
            if "pch_lvt" in line:
                x = line.split(' ')
                for j,value in enumerate(x):
                    if "pch_l" in value:
                        x[j] = "PCHPU_SR"
                    if "w=" in value:
                        x[j] = "w=8E-08"
                out = ' '.join(x)
                out_file.append(out)
                print(out)
                continue
            if "nch_na" in line:
                x = line.split(' ')
                for j,value in enumerate(x):
                    if "nch" in value:
                        x[j] = "NCHPG_SR"
                    if "w=" in value:
                        x[j] = "w=9E-08"
                    if "l=" in value:
                        x[j] = "l=7.5E-08"
                out = ' '.join(x)
                out_file.append(out)
                print(out)
                continue
            if subcircuit == "dmem_sramSA8":
                if "M30" in line and "w=150.0n" in line:
                    out_file.append("MM30 VSSE BTPSA SI VSSE nch l=6E-08 w=1.3E-07 m=1\n")
                    print("MM30 VSSE BTPSA SI VSSE nch l=6E-08 w=1.3E-07 m=1")
                    continue
            if subcircuit == "icache_data_storeSA4":
                if "M28" in line:
                    out_file.append("MM28 VSSE BTPSA SI VSSE nch l=6E-08 w=1.3E-07 m=1\n")
                    print("MM28 VSSE BTPSA SI VSSE nch l=6E-08 w=1.3E-07 m=1")
                    continue
                if "M13" in line or "M30" in line or "M33" in line:
                    x = line.split(' ')
                    for j,value in enumerate(x):
                        if "m=" in value:
                            x[j] = "m=2\n"
                    out = ' '.join(x)
                    out_file.append(out)
                    print(out)
                    continue
                if "M27" in line or "M29" in line or "M34" in line:
                    x = line.split(' ')
                    for j,value in enumerate(x):
                        if "m=" in value:
                            x[j] = "m=4\n"
                    out = ' '.join(x)
                    out_file.append(out)
                    print(out)
                    continue
            # if subcircuit == "icache_tag_store":
            #     if "<" in line:
            #         out = line.replace('<','[')
            #         out = out.replace('>',']')
            #         out_file.append(out)
            #         print(out)
            #         continue
            # if subcircuit == "dmem_sram":
            #     if "<" in line:
            #         out = line.replace('<','[')
            #         out = out.replace('>',']')
            #         out_file.append(out)
            #         print(out)
            #         continue
            # if subcircuit == "icache_data_store":
            #     if "<" in line:
            #         out = line.replace('<','[')
            #         out = out.replace('>',']')
            #         out_file.append(out)
            #         print(out)
            #         continue
            # if subcircuit == "chiptop":
            #     if "<" in line:
            #         out = line.replace('<','[')
            #         out = out.replace('>',']')
            #         out_file.append(out)
            #         print(out)
            #         continue
            if subcircuit == "icache_tag_storeSA4":
                if "M28" in line and "w=150.0n" in line:
                    out_file.append("MM28 VSSE BTPSA SI VSSE nch l=6E-08 w=1.3E-07 m=1\n")
                    print("MM28 VSSE BTPSA SI VSSE nch l=6E-08 w=1.3E-07 m=1")
                    continue
                if "M13" in line or "M30" in line or "M33" in line:
                    x = line.split(' ')
                    for j,value in enumerate(x):
                        if "m=" in value:
                            x[j] = "m=2\n"
                    out = ' '.join(x)
                    out_file.append(out)
                    print(out)
                    continue
                if "M27" in line or "M29" in line or "M34" in line:
                    x = line.split(' ')
                    for j,value in enumerate(x):
                        if "m=" in value:
                            x[j] = "m=4\n"
                    out = ' '.join(x)
                    out_file.append(out)
                    print(out)
                    continue
            out_file.append(line)  

        out_netlist_file = open("lvs/out."+file,"w")
        out_netlist_file.writelines(out_file)
        out_netlist_file.close()
        netlist_file.close()

if __name__ == "__main__":
    files = []
    # files.append("dmem_sram.src.net")
    # files.append("chiptop.src.net")
    files.append("chiptop.src.net")
    # files.append("icache_tag_store.src.net")
    # files.append("icache_data_store.src.net")
    replace_transistors(files)