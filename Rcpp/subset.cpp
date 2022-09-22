#include <Rcpp.h>

// [[Rcpp::export]]
Rcpp::DataFrame low_coverage_gene(Rcpp::DataFrame low_coverage_bases, Rcpp::DataFrame all_genes){
    Rcpp::IntegerVector start_out; 
    Rcpp::IntegerVector end_out; 
    Rcpp::StringVector id_out;

    if(low_coverage_bases.nrow() == 0){
    Rcpp::DataFrame low_coverage_genes = 
	  Rcpp::DataFrame::create(Rcpp::Named("start") = start_out,
				  Rcpp::Named("end") = end_out,
				  Rcpp::Named("name")= id_out);

    
    return low_coverage_genes;
    }

    
    Rcpp::IntegerVector start = low_coverage_bases["start"];
    Rcpp::IntegerVector end = low_coverage_bases["end"];
    Rcpp::IntegerVector gene_start = all_genes["start"];
    Rcpp::IntegerVector gene_end = all_genes["end"];
    Rcpp::StringVector   gene_names = all_genes["id"]; 

    
for (int i = 0; i < start.length(); i++) {
    for(int j = 1; j < gene_start.length(); j ++){
        if(start[i] <= gene_start[j] && end[i] >= gene_end[j] || 
           start[i] >= gene_start[j] && end[i] <= gene_end[j] ||
           start[i] <= gene_start[j] && gene_start[j] < end[i]||
           start[i] >= gene_start[j] && start[i] < gene_end[j]){
            
            start_out.push_back(gene_start[j]);
            end_out.push_back(gene_end[j]);
            if(gene_names[j] == "XXX")
                id_out.push_back("Not annotated"  + std::to_string(j));
            else    
                id_out.push_back(gene_names[j]);

        }
    }
}
Rcpp::DataFrame low_coverage_genes = 
	  Rcpp::DataFrame::create(Rcpp::Named("start")=start_out,
				  Rcpp::Named("end")=end_out,
				  Rcpp::Named("name")=id_out);

    
    return low_coverage_genes; 


}


// [[Rcpp::export]]
Rcpp::DataFrame low_coverage_gene_window(Rcpp::DataFrame coverage_data, Rcpp::DataFrame all_genes, int limit, int window){
    

    Rcpp::IntegerVector coverage = coverage_data["V3"];
    Rcpp::IntegerVector gene_start = all_genes["start"];
    Rcpp::IntegerVector gene_end = all_genes["end"];
    Rcpp::StringVector   gene_names = all_genes["id"]; 

    Rcpp::IntegerVector start_out; 
    Rcpp::IntegerVector end_out; 
    Rcpp::StringVector id_out;

     
    
    for(int j = 1; j < gene_start.length(); j ++){
        for(int l = gene_start[j]; l < gene_end[j]-window; l++){
            int coverage_val = 0;
            for(int z = 0; z < window; z++){
                coverage_val += coverage.at(l+z);
            }
            if((coverage_val/window)<=limit){
                start_out.push_back(gene_start[j]);
            end_out.push_back(gene_end[j]);
            if(gene_names[j] == "XXX")
                id_out.push_back("Not annotated"  + std::to_string(j));
            else    
                id_out.push_back(gene_names[j]);
            break; 
            }   
        }
    }
Rcpp::DataFrame low_coverage_genes = 
	  Rcpp::DataFrame::create(Rcpp::Named("start")=start_out,
				  Rcpp::Named("end")=end_out,
				  Rcpp::Named("name")=id_out);

    
    return low_coverage_genes; 


}
