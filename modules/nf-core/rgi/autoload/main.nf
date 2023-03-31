

process RGI_AUTOLOAD {
    label 'process_single'

    conda "bioconda::rgi=6.0.2"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/rgi:6.0.2--pyha8f3691_0':
        'quay.io/biocontainers/rgi:6.0.2--pyha8f3691_0' }"

    // no input needed, auto-download of CARD db
    input:

    output:
    path "card_db/"               , emit: card_db, optional: true
    env VER                       , emit: tool_version, optional: true 
    env DBVER                     , emit: db_version, optional: true
    path "versions.yml"           , emit: versions, optional: true

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    
    // rgi auto_load does not work, because the output directory cannot be specified
    /*
    wget https://card.mcmaster.ca/latest/data -P $PWD
    tar -xvf $PWD/data /card.json

    VER=\$(rgi main --version)
    DBVER=\$(rgi database --version)

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        rgi: \$(echo \$VER)
        rgi-database: \$(echo \$DBVER)
    END_VERSIONS
    */
    """
    export RGI_AUTOLOAD_DIR='./card_db'
    
    rgi \\
        auto_load

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        rgi: \$(echo \$(rgi main --version 2>&1))
        rgi-database: \$(echo \$(rgi database --version 2>&1))
    END_VERSIONS

    """
}
