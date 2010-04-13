$(document).ready(function() {
	$('#cadastros #listar').dataTable( {

        "bPaginate": true,
		"bLengthChange": true,
		"bFilter": true,
		"bSort": true,
		"bInfo": true,
		"bAutoWidth": true,
        "aoColumns": [
		{ "sType": "html" }

		],
/* TRADUCAO DE ELEMENTOS DOS MENUS */
        "oLanguage": {
			"sLengthMenu": "Mostra _MENU_ registros por página",
			"sZeroRecords": "Nada encontrado - desculpe",
			"sInfo": "Mostrando _START_ a _END_ de _TOTAL_ registros",
			"sInfoEmtpy": "Mostrando 0 de 0 de 0 registros",
            "sSearch": "Filtrar nos resultados:",
			"sInfoFiltered": "(Filtrando de _MAX_ total de registros)",
            "BStateSave": true,

/* TRADUCAO DA  PAGINACAO*/

            "oPaginate": {
		            "sFirst":    "Primeira",
		            "sPrevious": "Anterior",
		            "sNext":     "Próximo",
		            "sLast":     "Última"
	         }
		}


	} );
/* AUDITORIAS */
$('#exibir_auditorias #listar').dataTable( {
        "bPaginate": true,
		"bLengthChange": true,
		"bFilter": true,
		"bSort": false,
		"bInfo": true,
		"bAutoWidth": true,
        
/* TRADUCAO DE ELEMENTOS DOS MENUS */
        "oLanguage": {
			"sLengthMenu": "Mostra _MENU_ registros por página",
			"sZeroRecords": "Nada encontrado - desculpe",
			"sInfo": "Mostrando _START_ a _END_ de _TOTAL_ registros",
			"sInfoEmtpy": "Mostrando 0 de 0 de 0 registros",
            "sSearch": "Filtrar nos resultados:",
			"sInfoFiltered": "(Filtrando de _MAX_ total de registros)",
            "BStateSave": true,

/* TRADUCAO DA  PAGINACAO*/

            "oPaginate": {
		            "sFirst":    "Primeira",
		            "sPrevious": "Anterior",
		            "sNext":     "Próximo",
		            "sLast":     "Última"
	         }
		}


	} );

 } );
