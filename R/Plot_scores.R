plot_scores <- function(scores){
  
  plot_theme <-function(legend = TRUE, base_txt_size = 24){
    
    out <-
      
      theme_classic(base_size = base_txt_size, base_family = "") +
      
      theme(plot.title = element_text(hjust = 0.5, face = "bold"),
            legend.title = element_blank(),
            axis.text = element_text(size = 20),
            axis.text.x = element_text(angle = 90, vjust = 0.5),
            axis.title = element_text(face = "bold"),
            strip.background = element_blank(),
            strip.text.x = element_blank(),
            panel.spacing.y = unit(2, "lines")
      )
    
    if(!legend) out <- out + theme(legend.position = "none")
    
    return(out)
    
  }
  
  
  plot_data <- scores %>%
    
    tidyr::pivot_longer(cols = -Mixture,
                        names_to = "population",
                        values_to = "score") %>%
    
    dplyr::mutate(across(population, factor)) %>%
    
    dplyr::mutate(across(population, 
                         ~forcats::fct_relevel(., c("AC","MES","NPC", "OPC",
                                                    "DC","Mast Cells","B Cells",
                                                    "T Cells", "NK Cells", "Monocyte",
                                                    "Macrophage", "Microglia")))
    )
  
  
  ggplot(data = plot_data, aes(Mixture, score, fill = population)) +
    
    geom_bar(stat = "identity") +
    
    scale_fill_manual(values = plot_cols) +
    
    labs(x = "", 
         y = "Cell Type Estimates\n") +
    
    facet_wrap(facets = ~population,
               ncol = 1, scales = "free_y") +
    
    plot_theme(legend = TRUE)
  
  
  
}