#include <Rcpp.h>

// [[Rcpp::export]]
Rcpp::DataFrame remove_duplicates(Rcpp::DataFrame all_genes){
    
    Rcpp::IntegerVector gene_start = all_genes["start"];
    Rcpp::IntegerVector gene_end = all_genes["end"];
    Rcpp::StringVector   gene_names = all_genes["id"]; 

    Rcpp::IntegerVector start_out; 
    Rcpp::IntegerVector end_out; 
    Rcpp::StringVector id_out;

    start_out.push_back(gene_start[0]);
    end_out.push_back(gene_end[0]);
    id_out.push_back(gene_names[0]);
     
    
    for(int j = 1; j < gene_start.length(); j ++){
        if(gene_start[j] != gene_start[j-1] || gene_end[j] != gene_end[j-1]){
            start_out.push_back(gene_start[j]);
            end_out.push_back(gene_end[j]);
            id_out.push_back(gene_names[j]);
        }
    }
Rcpp::DataFrame unique_genes = 
	  Rcpp::DataFrame::create(Rcpp::Named("start")=start_out,
				  Rcpp::Named("end")=end_out,
				  Rcpp::Named("id")=id_out);

    
    return unique_genes; 


}