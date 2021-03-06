scratch="-t /dev/shm/raetzw_tmp"
numthreads="-e 6"
mem_limit="-m 50M"
cur_cache="-c 5M"
show_progress="-p"
force_overwrite="-f"
show_details="-x"
split_spot="-s"
split_file="-S"
split_3="-3"
rowid_as_name="-N"
skip_technical="-T"
print_frag_nr="-P"

# $1...file1, $2...md5
compare_md5()
{
    sum1=`md5sum $1 | awk '{print $1}'`
    if [ "$sum1" == "$2" ]
    then
        echo "$1 ... OK"
    else
        echo "$1 ... ERR ( $sum1 != $2 )"
    fi
}

fastdump_split_3()
{
    echo "***** fastdump database split into 3 files *****"
    out="/dev/shm/raetzw_out/$1.fastq"
    
    rm -rf $out $out.1 $out.2

    options="$show_progress $force_overwrite $show_details $split_3"
    time fasterq-dump $1 $options $numthreads $mem_limit $cur_cache $scratch -o $out
    compare_md5 $out $2
    compare_md5 $out.1 $3
    compare_md5 $out.2 $4
    
    rm -rf $out $out.1 $out.2
}

fastdump_split_file_row_id_as_name()
{
    echo "***** fastdump database split into files with rowid as name *****"
    out="/dev/shm/raetzw_out/$1.fastq"

    rm -rf $out.1 $out.2

    options="$show_progress $force_overwrite $show_details $split_spot $split_file $rowid_as_name"
    time fasterq-dump $1 $options $numthreads $mem_limit $cur_cache $scratch -o $out
    compare_md5 $out.1 $2
    compare_md5 $out.2 $3
    
    rm -rf $out.1 $out.2
}

fastdump_split_file()
{
    echo "***** fastdump database split into files *****"
    out="/dev/shm/raetzw_out/$1.fastq"
    
    rm -rf $out.1 $out.2

    options="$show_progress $force_overwrite $show_details $split_spot $split_file"
    time fasterq-dump $1 $options $numthreads $mem_limit $cur_cache $scratch -o $out
    compare_md5 $out.1 $2
    compare_md5 $out.2 $3
    
    rm -rf $out.1 $out.2
}

fastdump_split_file_4()
{
    echo "***** fastdump database split into files *****"
    out="/dev/shm/raetzw_out/$1.fastq"
    
    rm -rf $out.1 $out.2 $out.3 $out.4

    options="$show_progress $force_overwrite $show_details $split_spot $split_file"
    time fasterq-dump $1 $options $numthreads $mem_limit $cur_cache $scratch -o $out
    compare_md5 $out.1 $2
    compare_md5 $out.2 $3
    compare_md5 $out.3 $4
    compare_md5 $out.4 $5
    
    rm -rf $out.1 $out.2 $out.3 $out.4
}

fastdump_split_row_id_as_name()
{
    echo "***** fastdump database split with rowid as name *****"
    out="/dev/shm/raetzw_out/$1.fastq"
    
    rm -rf $out

    options="$show_progress $force_overwrite $show_details $split_spot $rowid_as_name"
    time fasterq-dump $1 $options $numthreads $mem_limit $cur_cache $scratch -o $out
    compare_md5 $out $2
    
    rm -rf $out
}

fastdump_split_spot()
{
    echo "***** fastdump database/table split *****"
    out="/dev/shm/raetzw_out/$1.fastq"
    
    rm -rf $out

    options="$show_progress $force_overwrite $show_details $split_spot"
    time fasterq-dump $1 $options $numthreads $mem_limit $cur_cache $scratch -o $out
    compare_md5 $out $2
    
    rm -rf $out
}

fastdump_not_split_row_id_as_name()
{
    echo "***** fastdump database not split with rowid as name *****"
    out="/dev/shm/raetzw_out/$1.fastq"
   
    rm -rf $out

    options="$show_progress $force_overwrite $show_details $rowid_as_name"    
    time fasterq-dump $1 $options $numthreads $mem_limit $cur_cache $scratch -o $out
    compare_md5 $out $2
    
    rm -rf $out
}

fastdump_not_split()
{
    echo "***** fastdump database not split *****"
    out="/dev/shm/raetzw_out/$1.fastq"
   
    rm -rf $out

    options="$show_progress $force_overwrite $show_details"
    time fasterq-dump $1 $options $numthreads $mem_limit $cur_cache $scratch -o $out
    compare_md5 $out $2
    
    rm -rf $out
}

test_csra()
{
    #a CSRA-database with SEQUENCE, PRIMARY_ALIGNMENT and REFERENCE
    csra="SRR341578"
    
    #none-splitted
    md5_csra_n="b6832cde19b4083ea0a5a246bad1a670"
    #splitted
    md5_csra_s="66b97c245a2c605a8854967b454d789e"
    md5_csra_1="087c5292b808e2d30dfd3d9e08ba3c56"
    md5_csra_2="38c926a3c56ee3833ddd2092cacd0129"

    fastdump_not_split $csra $md5_csra_n
    fastdump_not_split_row_id_as_name $csra $md5_csra_n
    fastdump_split_spot $csra $md5_csra_s
    fastdump_split_row_id_as_name $csra $md5_csra_s
    fastdump_split_file_row_id_as_name $csra $md5_csra_1 $md5_csra_2
    fastdump_split_file $csra $md5_csra_1 $md5_csra_2
}

test_sra_flat_1()
{
    #a flat SRA-table
    acc="SRR942391"
    
    #none-splitted
    md5_1="590366f579aa503bbedec1dab66df2ad"
    #splitted
    md5_2="a668be91b3e57b11fc56b977af1c1426"
    md5_3="fff51585bf9963419e4ce505c0f57637"
    md5_4="20784e715bd2498aca0e82ec61a195b9"

    fastdump_not_split $acc $md5_1
    fastdump_split_spot $acc $md5_2
    fastdump_split_file $acc $md5_3 $md5_4
}

test_sra_flat_2()
{
    #a flat SRA-table
    acc="SRR000001"
    #split-3
    md5_1="23b26de78b4b1d84ea47f3210e2a6f38"
    md5_2="331c1b6dc8f4e90e03d80d44fd6bb6e6"
    md5_3="83a27caacafc2bf1ed8ddfbe97dbc84d"

    fastdump_split_3 $acc $md5_1 $md5_2 $md5_3
}

test_sra_flat_4()
{
    #a flat SRA-table
    acc="SRR000001"
    #split-file ( this accession produces 4 files )
    md5_1="dfb375478199b08eac0a35742a8d0445"
    md5_2="0fa069beef66f89611fe53f8f195a713"
    md5_3="d3ce8a9eadf8987bab7687a1ee9f6a27"
    md5_4="7d0561fae55282fe2d38f71e49bcd6d6"
    
    fastdump_split_file_4 $acc $md5_1 $md5_2 $md5_3 $md5_4
}

test_sra_flat_split_spot()
{
    #a flat SRA-table
    acc="SRR000001"
    
    #split-spot ( this produces 1 file only )
    md5="29bb980236cc7df8c1d10bccab20b51f"
    
    fastdump_split_spot $acc $md5 $1
}

test_sra_db()
{
    #a flat SRA-table as the only table in a database
    acc="SRR6173369"
    
    #none-splitted
    md5_1="38250674922d516912b06498d8b4d3fb"
    #splitted
    md5_2="07106db1a11bdd1cc8c382a4e2482b5f"
    md5_3="c0be39a6d0566bfe72621e0a69cb2fe4"
    md5_4="0e560c82f092bac8b2d6e92c1262ed95"
    #split-3
    md5_5="8343497c5bbb5aa9f1d9ee4ea68196d2"
    md5_6="0e560c82f092bac8b2d6e92c1262ed95"
    md5_7="0e560c82f092bac8b2d6e92c1262ed95"
    
    fastdump_not_split $acc $md5_1
    fastdump_split_spot $acc $md5_2
    fastdump_split_file $acc $md5_3 $md5_4
    fastdump_split_3 $acc $md5_5 $md5_6 $md5_7
}

test_show_print_frag_nr()
{
    #a flat SRA-table
    acc="SRR000001"
    out="/dev/shm/raetzw_out/$acc.fastq"
    
    rm -rf $out

    options="$show_progress $force_overwrite $show_details $split_spot $print_frag_nr"
    time fasterq-dump $acc $options $numthreads $mem_limit $cur_cache $scratch -o $out
}

test_shorts()
{
    #acc="SRR000046"
    acc="SRR353889"
    out="$acc.out"
    cmd="fasterq-dump $acc -p -f -o $out $scratch"
    echo "time $cmd"
    time $cmd
}

test_too_big()
{
    acc="SRR001662"
    out="$acc.out"
    cmd="fasterq-dump $acc -p -f -o $out $scratch"
    echo "time $cmd"
    time $cmd
}

#test_shorts
test_too_big
#test_csra
#test_sra_flat_2
#test_sra_flat_4
#test_sra_flat_split_spot
#test_sra_db
#test_show_print_frag_nr
