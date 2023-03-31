#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { RGI_AUTOLOAD } from '../../../../../modules/nf-core/rgi/autoload/main.nf'

workflow test_rgi_autoload {
    
    RGI_AUTOLOAD ( )
}
