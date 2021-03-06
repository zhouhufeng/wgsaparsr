# freeze 4 field lists (freeze 5 uses config file - see config-tools.R)---------

#' define lists of fields in one place, and return based on argument
#' @noRd
.get_list <- function(which_list) {
  # fr_4_snv_desired------------------------------------------------------------
  if (which_list == "fr_4_snv_desired"){
    fr_4_snv_desired <- c(
      "chr",
      "pos",
      "ref",
      "alt",
      "VEP_ensembl_Consequence",
      "VEP_ensembl_Transcript_ID",
      "VEP_ensembl_Gene_Name",
      "VEP_ensembl_Gene_ID",
      "VEP_ensembl_Protein_ID",
      "VEP_ensembl_CCDS",
      "VEP_ensembl_SWISSPROT",
      "VEP_ensembl_Codon_Change_or_Distance", #note: change parsing on this one!
      "VEP_ensembl_Amino_Acid_Change",
      "VEP_ensembl_HGVSc",
      "VEP_ensembl_HGVSp",
      "VEP_ensembl_cDNA_position",
      "VEP_ensembl_CDS_position",
      "VEP_ensembl_Protein_position",
      "VEP_ensembl_Exon_or_Intron_Rank",
      "VEP_ensembl_STRAND",
      "VEP_ensembl_CANONICAL",
      "VEP_ensembl_LoF",
      "VEP_ensembl_LoF_filter",
      "VEP_ensembl_LoF_flags",
      "VEP_ensembl_LoF_info",
      "rs_dbSNP147",
      "splicing_consensus_ada_score",
      "splicing_consensus_rf_score",
      "GWAS_catalog_rs",
      "GWAS_catalog_trait",
      "GWAS_catalog_pubmedid",
      "clinvar_rs",
      "clinvar_clnsig",
      "clinvar_trait",
      "clinvar_golden_stars",
      "GTEx_V6_gene",
      "GTEx_V6_tissue",
      "MAP20",
      "MAP35",
      "MAP20_149bp",
      "MAP35_149bp",
      "GMS_single_end",
      "GMS_paired_end",
      "KGP_strict_masked",
      "RepeatMasker_masked",
      "Ancestral_allele",
      "AltaiNeandertal",
      "Denisova",
      "phyloP46way_primate",
      "phyloP46way_primate_rankscore",
      "phyloP46way_placental",
      "phyloP46way_placental_rankscore",
      "phyloP100way_vertebrate",
      "phyloP100way_vertebrate_rankscore",
      "phastCons46way_primate",
      "phastCons46way_primate_rankscore",
      "phastCons46way_placental",
      "phastCons46way_placental_rankscore",
      "phastCons100way_vertebrate",
      "phastCons100way_vertebrate_rankscore",
      "GERP_NR",
      "GERP_RS",
      "GERP_RS_rankscore",
      "SiPhy_29way_logOdds",
      "SiPhy_29way_logOdds_rankscore",
      "integrated_fitCons_score",
      "integrated_fitCons_rankscore",
      "integrated_confidence_value",
      "GM12878_fitCons_score",
      "GM12878_fitCons_rankscore",
      "GM12878_confidence_value",
      "H1_hESC_fitCons_score",
      "H1_hESC_fitCons_rankscore",
      "H1_hESC_confidence_value",
      "HUVEC_fitCons_score",
      "HUVEC_fitCons_rankscore",
      "HUVEC_confidence_value",
      "GenoCanyon_score",
      "GenoCanyon_rankscore",
      "KGP3_AC",
      "KGP3_AF",
      "KGP3_AFR_AC",
      "KGP3_AFR_AF",
      "KGP3_EUR_AC",
      "KGP3_EUR_AF",
      "KGP3_AMR_AC",
      "KGP3_AMR_AF",
      "KGP3_EAS_AC",
      "KGP3_EAS_AF",
      "KGP3_SAS_AC",
      "KGP3_SAS_AF",
      "RegulomeDB_motif",
      "RegulomeDB_score",
      "Motif_breaking",
      "CADD_raw",
      "CADD_phred",
      "CADD_raw_rankscore",
      "DANN_score",
      "DANN_rank_score",
      "fathmm_MKL_non_coding_score",
      "fathmm_MKL_non_coding_rankscore",
      "fathmm_MKL_non_coding_group",
      "fathmm_MKL_coding_score",
      "fathmm_MKL_coding_rankscore",
      "fathmm_MKL_coding_pred",
      "fathmm_MKL_coding_group",
      "Eigen_raw",
      "Eigen_phred",
      "Eigen_coding_or_noncoding",
      "Eigen_raw_rankscore",
      "Eigen_PC_raw",
      "Eigen_PC_raw_rankscore",
      "ENCODE_TFBS",
      "ENCODE_TFBS_score",
      "ENCODE_TFBS_cells",
      "ENCODE_Dnase_score",
      "ENCODE_Dnase_cells",
      "EnhancerFinder_general_developmental_enhancer",
      "EnhancerFinder_brain_enhancer",
      "EnhancerFinder_heart_enhancer",
      "EnhancerFinder_limb_enhancer",
      "FANTOM5_enhancer_permissive",
      "FANTOM5_enhancer_robust",
      "FANTOM5_enhancer_target",
      "FANTOM5_enhancer_expressed_tissue_cell",
      "FANTOM5_enhancer_differentially_expressed_tissue_cell",
      "FANTOM5_CAGE_peak_permissive",
      "FANTOM5_CAGE_peak_robust",
      "Ensembl_Regulatory_Build_Overviews",
      "Ensembl_Regulatory_Build_TFBS",
      "SIFT4G_AAref", # for SNV file, to pivot
      "SIFT4G_AAalt", # for SNV file, to pivot
      "SIFT4G_AApos", # for SNV file, to pivot
      "SIFT4G_score", # for SNV file, to pivot
      "SIFT4G_pred" # for SNV file, to pivot
    )
    return(fr_4_snv_desired)

  } else if (which_list == "fr_4_snv_to_split_VEP"){
    # fr_4_snv_to_split_VEP-----------------------------------------------------
    fr_4_snv_to_split_VEP <- c(
      "VEP_ensembl_Consequence",
      "VEP_ensembl_Transcript_ID",
      "VEP_ensembl_Gene_Name",
      "VEP_ensembl_Gene_ID",
      "VEP_ensembl_Protein_ID",
      "VEP_ensembl_CCDS",
      "VEP_ensembl_SWISSPROT",
      "VEP_ensembl_Codon_Change_or_Distance", #note: change parsing on this one!
      "VEP_ensembl_Amino_Acid_Change",
      "VEP_ensembl_HGVSc",
      "VEP_ensembl_HGVSp",
      "VEP_ensembl_cDNA_position",
      "VEP_ensembl_CDS_position",
      "VEP_ensembl_Protein_position",
      "VEP_ensembl_Exon_or_Intron_Rank",
      "VEP_ensembl_STRAND",
      "VEP_ensembl_CANONICAL",
      "VEP_ensembl_LoF",
      "VEP_ensembl_LoF_filter",
      "VEP_ensembl_LoF_flags",
      "VEP_ensembl_LoF_info",
      "SIFT4G_AAref", # for SNV file, to pivot
      "SIFT4G_AAalt", # for SNV file, to pivot
      "SIFT4G_AApos", # for SNV file, to pivot
      "SIFT4G_score", # for SNV file, to pivot
      "SIFT4G_pred"
    )
    return(fr_4_snv_to_split_VEP)

  } else if (which_list == "fr_4_snv_to_split_TFBS"){
    # fr_4_snv_to_split_TFBS----------------------------------------------------
    fr_4_snv_to_split_TFBS <- c(
      "ENCODE_TFBS",
      "ENCODE_TFBS_score",
      "ENCODE_TFBS_cells"
    )
    return(fr_4_snv_to_split_TFBS)

  } else if (which_list == "fr_4_snv_to_split_GTEx_V6"){
    # fr_4_snv_to_split_GTEx_V6-------------------------------------------------
    fr_4_snv_to_split_GTEx_V6 <- c(
      "GTEx_V6_gene",
      "GTEx_V6_tissue"
    )
    return(fr_4_snv_to_split_GTEx_V6)

  } else if (which_list == "fr_4_snv_post_processing") {
    # fr_4_dbnsfp_post_processing-----------------------------------------------
    # replace "VEP_ensembl_Codon_Change_or_Distance" with
    # "VEP_ensembl_Distance" and "VEP_ensembl_Codon_Change"
    unmodified <- .get_list("fr_4_snv_desired")
    unmodified[unmodified == "VEP_ensembl_Codon_Change_or_Distance"] <-
      "VEP_ensembl_Distance"
    fr_4_snv_post_processing <- c(
      unmodified,
      "VEP_ensembl_Codon_Change",
      "wgsa_version")
    return(fr_4_snv_post_processing)

  } else if (which_list == "fr_4_indel_desired") {
    # fr_4_indel_desired--------------------------------------------------------
    fr_4_indel_desired <- c(
      "#chr",
      "pos",
      "ref",
      "alt",
      "VEP_ensembl_Consequence",
      "VEP_ensembl_Transcript_ID",
      "VEP_ensembl_Gene_Name",
      "VEP_ensembl_Gene_ID",
      "VEP_ensembl_Protein_ID",
      "VEP_ensembl_CCDS",
      "VEP_ensembl_SWISSPROT",
      "VEP_ensembl_Codon_Change_or_Distance",
      "VEP_ensembl_Amino_Acid_Change",
      "VEP_ensembl_HGVSc",
      "VEP_ensembl_HGVSp",
      "VEP_ensembl_cDNA_position",
      "VEP_ensembl_CDS_position",
      "VEP_ensembl_Protein_position",
      "VEP_ensembl_Exon_or_Intron_Rank",
      "VEP_ensembl_STRAND",
      "VEP_ensembl_CANONICAL",
      "VEP_ensembl_LoF",
      "VEP_ensembl_LoF_filter",
      "VEP_ensembl_LoF_flags",
      "VEP_ensembl_LoF_info",
      "rs_dbSNP147",
      "CADDraw",
      "CADDphred",
      "GWAS_catalog_rs",
      "GWAS_catalog_trait",
      "GWAS_catalog_pubmedid",
      "clinvar_rs",
      "clinvar_clnsig",
      "clinvar_trait",
      "clinvar_golden_stars",
      "GTEx_V6_gene",
      "GTEx_V6_tissue",
      "1000Gp3_AC",
      "1000Gp3_AF",
      "1000Gp3_AFR_AC",
      "1000Gp3_AFR_AF",
      "1000Gp3_EUR_AC",
      "1000Gp3_EUR_AF",
      "1000Gp3_AMR_AC",
      "1000Gp3_AMR_AF",
      "1000Gp3_EAS_AC",
      "1000Gp3_EAS_AF",
      "1000Gp3_SAS_AC",
      "1000Gp3_SAS_AF",
      "indel_focal_length",
      "focal_snv_number",
      "splicing_consensus_ada_score",
      "splicing_consensus_rf_score",
      "MAP20",
      "MAP35",
      "MAP20(+-149bp)",
      "MAP35(+-149bp)",
      "GMS_single-end",
      "GMS_paired-end",
      "1000G_strict_masked",
      "RepeatMasker_masked",
      "phyloP46way_primate",
      "phyloP46way_primate_rankscore",
      "phyloP46way_placental",
      "phyloP46way_placental_rankscore",
      "phyloP100way_vertebrate",
      "phyloP100way_vertebrate_rankscore",
      "phastCons46way_primate",
      "phastCons46way_primate_rankscore",
      "phastCons46way_placental",
      "phastCons46way_placental_rankscore",
      "phastCons100way_vertebrate",
      "phastCons100way_vertebrate_rankscore",
      "GERP_NR",
      "GERP_RS",
      "GERP_RS_rankscore",
      "SiPhy_29way_logOdds",
      "SiPhy_29way_logOdds_rankscore",
      "integrated_fitCons_score",
      "integrated_fitCons_rankscore",
      "integrated_confidence_value",
      "GM12878_fitCons_score",
      "GM12878_fitCons_rankscore",
      "H1-hESC_fitCons_score",
      "H1-hESC_fitCons_rankscore",
      "HUVEC_fitCons_score",
      "HUVEC_fitCons_rankscore",
      "GenoCanyon_score",
      "GenoCanyon_rankscore",
      "RegulomeDB_motif",
      "RegulomeDB_score",
      "Motif_breaking",
      "DANN_score",
      "DANN_rank_score",
      "fathmm-MKL_non-coding_score",
      "fathmm-MKL_non-coding_rankscore",
      "fathmm-MKL_coding_score",
      "fathmm-MKL_coding_rankscore",
      "Eigen-raw",
      "Eigen-phred",
      "Eigen-raw_rankscore",
      "Eigen-PC-raw",
      "Eigen-PC-raw_rankscore",
      "ENCODE_TFBS",
      "ENCODE_TFBS_score",
      "ENCODE_TFBS_cells",
      "ENCODE_Dnase_score",
      "ENCODE_Dnase_cells",
      "EnhancerFinder_general_developmental_enhancer",
      "EnhancerFinder_brain_enhancer",
      "EnhancerFinder_heart_enhancer",
      "EnhancerFinder_limb_enhancer",
      "FANTOM5_enhancer_permissive",
      "FANTOM5_enhancer_robust",
      "FANTOM5_enhancer_target",
      "FANTOM5_enhancer_expressed_tissue_cell",
      "FANTOM5_enhancer_differentially_expressed_tissue_cell",
      "FANTOM5_CAGE_peak_permissive",
      "FANTOM5_CAGE_peak_robust",
      "Ensembl_Regulatory_Build_Overviews",
      "Ensembl_Regulatory_Build_TFBS"
    )
    return(fr_4_indel_desired)

  } else if (which_list == "fr_4_indel_to_split") {
    # fr_4_indel_to_split-------------------------------------------------------
    fr_4_indel_to_split <- c(
      "VEP_ensembl_Consequence",
      "VEP_ensembl_Transcript_ID",
      "VEP_ensembl_Gene_Name",
      "VEP_ensembl_Gene_ID",
      "VEP_ensembl_Protein_ID",
      "VEP_ensembl_CCDS",
      "VEP_ensembl_SWISSPROT",
      "VEP_ensembl_Codon_Change_or_Distance",
      "VEP_ensembl_Amino_Acid_Change",
      "VEP_ensembl_HGVSc",
      "VEP_ensembl_HGVSp",
      "VEP_ensembl_cDNA_position",
      "VEP_ensembl_CDS_position",
      "VEP_ensembl_Protein_position",
      "VEP_ensembl_Exon_or_Intron_Rank",
      "VEP_ensembl_STRAND",
      "VEP_ensembl_CANONICAL",
      "VEP_ensembl_LoF",
      "VEP_ensembl_LoF_filter",
      "VEP_ensembl_LoF_flags",
      "VEP_ensembl_LoF_info"
      )
    return(fr_4_indel_to_split)

  } else if (which_list == "fr_4_indel_max_columns") {
    # fr_4_indel_max_columns----------------------------------------------------
    fr_4_indel_max_columns <- c(
      "splicing_consensus_ada_score",
      "splicing_consensus_rf_score",
      "MAP20",
      "MAP35",
      "MAP20(+-149bp)",
      "MAP35(+-149bp)",
      "GMS_single-end",
      "GMS_paired-end",
      "ENCODE_TFBS_score",
      "ENCODE_Dnase_score",
      "ENCODE_Dnase_cells"
    )
    return(fr_4_indel_max_columns)

  } else if (which_list == "fr_4_indel_triple_columns") {
    # fr_4_indel_triple_columns-------------------------------------------------
    parse_triples <- list(
      c(
        "Eigen-raw",
        "Eigen-raw_rankscore",
        "Eigen-phred"
      )
    )
    return(parse_triples)

  } else if (which_list == "fr_4_indel_pair_columns") {
    # fr_4_indel_pair_columns---------------------------------------------------
    parse_pairs <- list(
      c("phyloP46way_primate",
        "phyloP46way_primate_rankscore"),
      c("phyloP46way_placental",
        "phyloP46way_placental_rankscore"),
      c("phyloP100way_vertebrate",
        "phyloP100way_vertebrate_rankscore"),
      c("phastCons46way_primate",
        "phastCons46way_primate_rankscore"),
      c("phastCons46way_placental",
        "phastCons46way_placental_rankscore"),
      c("phastCons100way_vertebrate",
        "phastCons100way_vertebrate_rankscore"),
      c("SiPhy_29way_logOdds",
        "SiPhy_29way_logOdds_rankscore"),
      c("GenoCanyon_score",
        "GenoCanyon_rankscore"),
      c("DANN_score",
        "DANN_rank_score"),
      c("Eigen-PC-raw",
        "Eigen-PC-raw_rankscore"),
      c("GERP_RS",
        "GERP_RS_rankscore"),
      c("integrated_fitCons_score",
        "integrated_fitCons_rankscore"),
      c("GM12878_fitCons_score",
        "GM12878_fitCons_rankscore"),
      c("H1-hESC_fitCons_score",
        "H1-hESC_fitCons_rankscore"),
      c("HUVEC_fitCons_score",
        "HUVEC_fitCons_rankscore"),
      c("fathmm-MKL_non-coding_score",
        "fathmm-MKL_non-coding_rankscore"),
      c("fathmm-MKL_coding_score",
        "fathmm-MKL_coding_rankscore")
    )
    return(parse_pairs)

  } else if (which_list == "fr_4_indel_yes_columns") {
    # fr_4_indel_yes_columns----------------------------------------------------
    parse_string_yes <- c(
      "EnhancerFinder_general_developmental_enhancer",
      "EnhancerFinder_brain_enhancer",
      "EnhancerFinder_heart_enhancer",
      "EnhancerFinder_limb_enhancer",
      "FANTOM5_enhancer_permissive",
      "FANTOM5_enhancer_robust",
      "FANTOM5_CAGE_peak_permissive",
      "FANTOM5_CAGE_peak_robust",
      "RepeatMasker_masked"
    )
    return(parse_string_yes)

  } else if (which_list == "fr_4_indel_no_columns") {
    # fr_4_indel_no_columns-----------------------------------------------------
    parse_string_no <- c(
      "1000G_strict_masked"
    )
    return(parse_string_no)

    } else if (which_list == "fr_4_indel_post_processing") {
      # fr_4_indel_post_processing----------------------------------------------
      fr_4_indel_post_processing <- c(
        "chr",
        "pos",
        "ref",
        "alt",
        "rs_dbSNP147",
        "Eigen_PC_raw_unparsed",
        "Eigen_PC_raw_rankscore_unparsed",
        "GWAS_catalog_rs",
        "GWAS_catalog_trait",
        "GWAS_catalog_pubmedid",
        "clinvar_rs",
        "clinvar_clnsig",
        "clinvar_trait",
        "clinvar_golden_stars",
        "GTEx_V6_gene",
        "GTEx_V6_tissue",
        "KGP3_AC",
        "KGP3_AF",
        "KGP3_EUR_AC",
        "KGP3_EUR_AF",
        "KGP3_AMR_AC",
        "KGP3_AMR_AF",
        "KGP3_EAS_AC",
        "KGP3_EAS_AF",
        "KGP3_SAS_AC",
        "KGP3_SAS_AF",
        "MAP20_149bp_unparsed",
        "MAP35_149bp_unparsed",
        "GMS_single_end_unparsed",
        "GMS_paired_end_unparsed",
        "KGP_strict_masked_unparsed",
        "indel_focal_length",
        "focal_snv_number",
        "splicing_consensus_ada_score_unparsed",
        "splicing_consensus_rf_score_unparsed",
        "MAP20_unparsed",
        "MAP35_unparsed",
        "MAP20_149bp",
        "MAP35_149bp",
        "GMS_single_end",
        "GMS_paired_end",
        "KGP_strict_masked",
        "RepeatMasker_masked_unparsed",
        "phyloP46way_primate_unparsed",
        "phyloP46way_primate_rankscore_unparsed",
        "phyloP46way_placental_unparsed",
        "phyloP46way_placental_rankscore_unparsed",
        "phyloP100way_vertebrate_unparsed",
        "phyloP100way_vertebrate_rankscore_unparsed",
        "phastCons46way_primate_unparsed",
        "phastCons46way_primate_rankscore_unparsed",
        "phastCons46way_placental_unparsed",
        "phastCons46way_placental_rankscore_unparsed",
        "phastCons100way_vertebrate_unparsed",
        "phastCons100way_vertebrate_rankscore_unparsed",
        "GERP_NR",
        "GERP_RS_unparsed",
        "GERP_RS_rankscore_unparsed",
        "SiPhy_29way_logOdds_unparsed",
        "SiPhy_29way_logOdds_rankscore_unparsed",
        "integrated_fitCons_score_unparsed",
        "integrated_fitCons_rankscore_unparsed",
        "integrated_confidence_value",
        "GM12878_fitCons_score_unparsed",
        "GM12878_fitCons_rankscore_unparsed",
        "Eigen_PC_raw",
        "Eigen_PC_raw_rankscore",
        "HUVEC_fitCons_score_unparsed",
        "HUVEC_fitCons_rankscore_unparsed",
        "GenoCanyon_score_unparsed",
        "GenoCanyon_rankscore_unparsed",
        "RegulomeDB_motif",
        "RegulomeDB_score",
        "Motif_breaking",
        "DANN_score_unparsed",
        "DANN_rank_score_unparsed",
        "H1_hESC_fitCons_score",
        "H1_hESC_fitCons_rankscore",
        "fathmm_MKL_non_coding_score",
        "fathmm_MKL_non_coding_rankscore",
        "fathmm_MKL_coding_score",
        "fathmm_MKL_coding_rankscore",
        "Eigen_raw",
        "Eigen_raw_rankscore",
        "Eigen_phred",
        "ENCODE_TFBS",
        "ENCODE_TFBS_score_unparsed",
        "ENCODE_TFBS_cells",
        "ENCODE_Dnase_score_unparsed",
        "ENCODE_Dnase_cells_unparsed",
        "EnhancerFinder_general_developmental_enhancer_unparsed",
        "EnhancerFinder_brain_enhancer_unparsed",
        "EnhancerFinder_heart_enhancer_unparsed",
        "EnhancerFinder_limb_enhancer_unparsed",
        "FANTOM5_enhancer_permissive_unparsed",
        "FANTOM5_enhancer_robust_unparsed",
        "FANTOM5_enhancer_target",
        "FANTOM5_enhancer_expressed_tissue_cell",
        "FANTOM5_enhancer_differentially_expressed_tissue_cell",
        "FANTOM5_CAGE_peak_permissive_unparsed",
        "FANTOM5_CAGE_peak_robust_unparsed",
        "Ensembl_Regulatory_Build_Overviews",
        "Ensembl_Regulatory_Build_TFBS",
        "wgsa_version",
        "VEP_ensembl_Consequence",
        "VEP_ensembl_Transcript_ID",
        "VEP_ensembl_Gene_Name",
        "VEP_ensembl_Gene_ID",
        "VEP_ensembl_Protein_ID",
        "VEP_ensembl_CCDS",
        "VEP_ensembl_SWISSPROT",
        "VEP_ensembl_Distance",
        "VEP_ensembl_Codon_Change",
        "VEP_ensembl_Amino_Acid_Change",
        "VEP_ensembl_HGVSc",
        "VEP_ensembl_HGVSp",
        "VEP_ensembl_cDNA_position",
        "VEP_ensembl_CDS_position",
        "VEP_ensembl_Protein_position",
        "VEP_ensembl_Exon_or_Intron_Rank",
        "VEP_ensembl_STRAND",
        "VEP_ensembl_CANONICAL",
        "VEP_ensembl_LoF",
        "VEP_ensembl_LoF_filter",
        "VEP_ensembl_LoF_flags",
        "VEP_ensembl_LoF_info",
        "splicing_consensus_ada_score",
        "splicing_consensus_rf_score",
        "MAP20",
        "MAP35",
        "CADD_raw",
        "CADD_phred",
        "ENCODE_TFBS_score",
        "ENCODE_Dnase_score",
        "ENCODE_Dnase_cells",
        "EnhancerFinder_general_developmental_enhancer",
        "EnhancerFinder_brain_enhancer",
        "EnhancerFinder_heart_enhancer",
        "EnhancerFinder_limb_enhancer",
        "FANTOM5_enhancer_permissive",
        "FANTOM5_enhancer_robust",
        "FANTOM5_CAGE_peak_permissive",
        "FANTOM5_CAGE_peak_robust",
        "RepeatMasker_masked",
        "phyloP46way_primate",
        "phyloP46way_primate_rankscore",
        "phyloP46way_placental",
        "phyloP46way_placental_rankscore",
        "phyloP100way_vertebrate",
        "phyloP100way_vertebrate_rankscore",
        "phastCons46way_primate",
        "phastCons46way_primate_rankscore",
        "phastCons46way_placental",
        "phastCons46way_placental_rankscore",
        "phastCons100way_vertebrate",
        "phastCons100way_vertebrate_rankscore",
        "SiPhy_29way_logOdds",
        "SiPhy_29way_logOdds_rankscore",
        "GenoCanyon_score",
        "GenoCanyon_rankscore",
        "DANN_score",
        "DANN_rank_score",
        "Eigen_phred_unparsed",
        "Eigen_raw_rankscore_unparsed",
        "GERP_RS",
        "GERP_RS_rankscore",
        "integrated_fitCons_score",
        "integrated_fitCons_rankscore",
        "GM12878_fitCons_score",
        "GM12878_fitCons_rankscore",
        "KGP3_AFR_AC",
        "KGP3_AFR_AF",
        "HUVEC_fitCons_score",
        "HUVEC_fitCons_rankscore",
        "H1_hESC_fitCons_score_unparsed",
        "H1_hESC_fitCons_rankscore_unparsed",
        "fathmm_MKL_non_coding_score_unparsed",
        "fathmm_MKL_non_coding_rankscore_unparsed",
        "fathmm_MKL_coding_score_unparsed",
        "Eigen_raw_unparsed",
        "fathmm_MKL_coding_rankscore_unparsed"
      )
      return(fr_4_indel_post_processing)

  } else if (which_list == "fr_4_dbnsfp_desired") {
    # fr_4_dbnsfp_desired-------------------------------------------------------
    dbnsfp_desired_fr_4 <- c(
      "chr",
      "pos",
      "ref",
      "alt",
      "aaref",
      "aaalt",
      "Uniprot_acc",
      "Uniprot_id",
      "Uniprot_aapos",
      "Interpro_domain",
      "cds_strand",
      "refcodon",
      "SLR_test_statistic",
      "codonpos",
      "fold_degenerate",
      "Ensembl_geneid",
#      "Ensembl_transcriptid",
      "aapos",
      "Polyphen2_HDIV_score",
      "Polyphen2_HDIV_rankscore",
      "Polyphen2_HDIV_pred",
      "Polyphen2_HVAR_score",
      "Polyphen2_HVAR_rankscore",
      "Polyphen2_HVAR_pred",
      "LRT_score",
      "LRT_converted_rankscore",
      "LRT_pred",
      "MutationTaster_score",
      "MutationTaster_converted_rankscore",
      "MutationTaster_pred",
      "MutationAssessor_score",
      "MutationAssessor_rankscore",
      "MutationAssessor_pred",
      "FATHMM_score",
      "FATHMM_rankscore",
      "FATHMM_pred",
      "MetaSVM_score",
      "MetaSVM_rankscore",
      "MetaSVM_pred",
      "MetaLR_score",
      "MetaLR_rankscore",
      "MetaLR_pred",
      "Reliability_index",
      "VEST3_score",
      "VEST3_rankscore",
      "PROVEAN_score",
      "PROVEAN_converted_rankscore",
      "PROVEAN_pred"
    )
    return(dbnsfp_desired_fr_4)

  } else if (which_list == "fr_4_dbnsfp_to_split") {
    # fr_4_dbnsfp_to_split------------------------------------------------------
    dbnsfp_to_split_fr_4 <- c(
      "aaref",
      "aaalt",
      "Uniprot_acc",
      "Uniprot_id",
      "Uniprot_aapos",
      "Interpro_domain",
      "cds_strand",
      "refcodon",
      "SLR_test_statistic",
      "codonpos",
      "fold_degenerate",
      "Ensembl_geneid",
      #      "Ensembl_transcriptid",
      "aapos",
      "Polyphen2_HDIV_score",
      "Polyphen2_HDIV_rankscore",
      "Polyphen2_HDIV_pred",
      "Polyphen2_HVAR_score",
      "Polyphen2_HVAR_rankscore",
      "Polyphen2_HVAR_pred",
      "LRT_score",
      "LRT_converted_rankscore",
      "LRT_pred",
      "MutationTaster_score",
      "MutationTaster_converted_rankscore",
      "MutationTaster_pred",
      "MutationAssessor_score",
      "MutationAssessor_rankscore",
      "MutationAssessor_pred",
      "FATHMM_score",
      "FATHMM_rankscore",
      "FATHMM_pred",
      "MetaSVM_score",
      "MetaSVM_rankscore",
      "MetaSVM_pred",
      "MetaLR_score",
      "MetaLR_rankscore",
      "MetaLR_pred",
      "Reliability_index",
      "VEST3_score",
      "VEST3_rankscore",
      "PROVEAN_score",
      "PROVEAN_converted_rankscore",
      "PROVEAN_pred"
    )
    return(dbnsfp_to_split_fr_4)

  } else if (which_list == "fr_4_dbnsfp_low_pairs") {
    # fr_4_dbnsfp_low_pairs-----------------------------------------------------
    # a list of all possible fields in both SNV and indel annotaiton files -
    # new names, including "_unparsed" string
    dbnsfp_low_pairs_fr_4 <- list(
      c("PROVEAN_score", "PROVEAN_pred"),
      c("FATHMM_score", "FATHMM_pred")
      )
    return(dbnsfp_low_pairs_fr_4)

  } else if (which_list == "fr_4_dbnsfp_high_pairs") {
    # fr_4_dbnsfp_high_pairs----------------------------------------------------
    dbnsfp_high_pairs_fr_4 <- list(
      c("Polyphen2_HDIV_score", "Polyphen2_HDIV_pred"),
      c("Polyphen2_HVAR_score", "Polyphen2_HVAR_pred")
    )
    return(dbnsfp_high_pairs_fr_4)

  } else if (which_list == "fr_4_dbnsfp_mutation_pairs") {
    # fr_4_dbnsfp_mutation_pairs------------------------------------------------
    dbnsfp_mutation_pairs_fr_4 <- list(
      c("MutationTaster_pred", "MutationTaster_score")
    )
    return(dbnsfp_mutation_pairs_fr_4)

  } else if (which_list == "fr_4_dbnsfp_post_processing") {
    # fr_4_dbnsfp_post_processing-----------------------------------------------
    fr_4_dbnsfp_post_processing <- c(
      .get_list("fr_4_dbnsfp_desired"),
      "PROVEAN_score_unparsed", "PROVEAN_pred_unparsed",
      "FATHMM_score_unparsed", "FATHMM_pred_unparsed",
      "Polyphen2_HDIV_score_unparsed", "Polyphen2_HDIV_pred_unparsed",
      "Polyphen2_HVAR_score_unparsed", "Polyphen2_HVAR_pred_unparsed",
      "MutationTaster_pred_unparsed", "MutationTaster_score_unparsed",
      "aachange"
    )
    return(fr_4_dbnsfp_post_processing)

  } else {
    stop("Unknown list.")
  }
}
