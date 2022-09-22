#include <Rcpp.h>

/*
 * Function to determine all low coverage genes = genes that have one base position classified as low coverage
 * @param Rcpp::DataFrame low_coverage_bases : DataFrame that contains all bases classified as low coverage
 * @param Rcpp::DataFrame all_genes: DataFrame that contains start,end and id of every gene
 * @return Rcpp::DataFrame low_coverage_genes: Dataframe that contains all genes with at least one low coverage base
 */

// [[Rcpp::export]]
Rcpp::DataFrame low_coverage_gene(Rcpp::DataFrame &low_coverage_bases, Rcpp::DataFrame &all_genes){
    Rcpp::IntegerVector start_out; 
    Rcpp::IntegerVector end_out; 
    Rcpp::StringVector id_out;
    std::cout << low_coverage_bases.nrow() << std::endl;
    if(low_coverage_bases.nrow() > 0){
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

    }


    
    Rcpp::DataFrame low_coverage_genes = 
	Rcpp::DataFrame::create(Rcpp::Named("start")=start_out,
				            Rcpp::Named("end")=end_out,
				            Rcpp::Named("name")=id_out);

    
    return low_coverage_genes; 
}

/*
 * Function to determine all low coverage genes = genes that have low coverage over a whole window
 * @param Rcpp::DataFrame coverage_data : DataFrame that contains the coverage information of every base
 * @param Rcpp::DataFrame all_genes: DataFrame that contains start,end and id of every gene
 * @param int limit: threshold for low coverage
 * @param int window: window size for low coverage classification
 * @return Rcpp::DataFrame low_coverage_genes: Dataframe that contains all genes with a window of low coverage bases
 */

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
