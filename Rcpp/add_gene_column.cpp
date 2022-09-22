#include <Rcpp.h>
// [[Rcpp::export]]
Rcpp::DataFrame depth_with_gene(Rcpp::DataFrame &total_bases, Rcpp::DataFrame &all_genes){
    Rcpp::IntegerVector  bases = total_bases["V2"];
    Rcpp::IntegerVector gene_start = all_genes["start"];
    Rcpp::IntegerVector gene_end = all_genes["end"];
    Rcpp::StringVector  gene_names = all_genes["id"];
    Rcpp::StringVector gene_out(bases.length(),"no annotation") ;

    for(int k = 1; k < gene_start.length(); k++){
        for(int p = gene_start[k]; p < gene_end[k] ; p++){
                if(p < bases.length())
                    gene_out.at(p-1) = gene_names[k]; 
        }
    }
  
        //Rcpp::StringVector name_out2 =  Rcpp::StringVector(name_out,name_out+sizeof(name_out)/sizeof(*name_out));   
    Rcpp::DataFrame annotated_bases = 
	Rcpp::DataFrame::create(Rcpp::Named("V1")=total_bases["V1"],
				            Rcpp::Named("V2")=total_bases["V2"],
				            Rcpp::Named("V3")=total_bases["V3"],
                            Rcpp::Named("V4")=gene_out); 
                

    return annotated_bases; 
}


    

