@extends('newmaster')
@section('buttons')

@endsection
@section('content')
<div class="container-fluid">

  <!-- <div id="qrcode"></div> -->
  <div class="row">
    <div class="col-6 text-left">
      <h1>Report Pemasukan Barang</h1>
    </div>
    <div class="col-6 text-right">
      <!-- <button type="button" class="btn btn-primary btn-lg " style="height: 60px; " onclick="buttonAdd()"  >Add Perkiraan</button> -->
    </div>
  </div>
<!-- <button onclick="loadAll()">tes</button> -->
</div>

<div id="printContainer" style="display:none">

</div>
<div id="contentContainer" class="container-fluid">

          <div class="row">
              <!-- <div class="col-12 text-right">
                  <button type="button" class="btn btn-primary btn-lg " style="height: 60px; " onclick="buttonAdd()"  >Add Koreksi Stock Gudang</button>
              </div> -->
          </div>
          <div class="row text-right justify-content-center">
            <div class="card w-50">
              <div class="card-body">
                <h5 class="card-title text-left">Laporan Pemasukan Barang</h5>
                <div class="container-fluid">
                <div style="background-color: #E8E8E8; padding: 10px; " class="rounded">
                <div class="row " >
                  <h6 class="col-3 text-left">Periode</h6>
                </div>
                <div class="row text-center">
                  <div class="col-5"><input id="inputDate1" style="display: block; width: 100%" class="text-center" type="date" value="{!! date('Y-m-d') !!}">
                  </div>
                  <div class="col-2">s/d
                  </div>
                  <div class="col-5"><input id="inputDate2" style="display: block; width: 100%" class="text-center" type="date" value="{!! date('Y-m-d') !!}">
                  </div>
                </div>
              </div>

                <div class="row text-center mt-4">
                  <div class="col-6">
                    <select id="inputReport1" style="display: block; width: 100%"  class="form-select" aria-label="Default select example">
                      <option value=0>BC 2.6.2</option>
                      <option value=1>BC 2.3</option>
                      <option value=2>BC 4.0</option>
                      <option value=3>BC 2.7</option>
                    </select>
                  </div>
                  <!-- <div class="col-2">
                  </div> -->
                  <div class="col-6">
                    <select id="inputReport2" style="display: block; width: 100%" class="form-select form-select-sm" aria-label=".form-select-sm example">
                      <option value=0>Urut Dok. Pabean</option>
                      <option value=1>Urut Bukti LPB</option>
                    </select>
                  </div>
                </div>

                <div class="row text-center mt-4">
                  <div class="col-6">
                    <select id="inputReport3" style="display: block; width: 100%"  class="form-select" aria-label="Default select example">
                      <option value="All">All</option>
                      <option value="PHI001">PEIHAI</option>
                      <option value="PHJ001">JANTI</option>
                      <!-- <option value="3">BC 2.7</option> -->
                    </select>
                  </div>
                  <!-- <div class="col-2">
                  </div> -->
                  <div class="col-6">
                    <!-- <select style="display: block; width: 100%" class="form-select form-select-sm" aria-label=".form-select-sm example">
                      <option selected>Urut Dok. Pabean</option>
                      <option value="1">urut Bukti LPB</option> -->
                    </select>
                  </div>
                </div>
                <!-- <p class="card-text mt-4">With supporting text below as a natural lead-in to additional content.</p> -->
                <!-- <div class="row text-right"> -->
                  <a href="#" class="mt-4 btn btn-primary text-right justify-content-right" onclick="makeTable()">Submit</a>
                <!-- </div> -->
              </div>
              </div>
            </div>
          </div>

        <div class="container-fluid mt-6">
          <!-- <div class="row mt-6">
            <div class="col-12 text-left font-weight-bold">
              LAPORAN PEMASUKAN BARANG PER DOKUMEN PABEAN
            </div>
          </div>
          <div class="row">
            <div class="col-12 text-left font-weight-bold">
              KAWASAN BERIKAT PT. PEI HAI INTERNATIONAL WIRATAMA INDONESIA
            </div>
          </div>
          <div class="row">
            <div class="col-12 text-left font-weight-bold">
              LAPORAN PEMASUKAN BARANG PER DOKUMEN PABEAN
            </div>
          </div>
          <div class="row">
            <div class="col-12 text-left font-weight-bold">
              PERIODE:
            </div>
          </div> -->


          <div id="showTableReport" style="display:none; background-color: white; padding: 10px" class="row mt-4 rounded">
            <!-- <div class="row"> -->
            <!-- <div class="row"> -->
              <!-- <div class="col-2">
                <input id="inputDate1" style="display: block; width: 100%" class="text-center" type="date" value="{!! date('Y-m-d') !!}">
              </div>
              <div class="col-2">
                <input id="inputDate2" style="display: block; width: 100%" class="text-center" type="date" value="{!! date('Y-m-d') !!}">
              </div> -->
            <!-- </div> -->
              <div class="col-12 text-right">
                <button type="button" class="btn btn-success" onclick="exportTableToExcel('tabel')">Export to Excel</button>
                <button type="button" class="btn btn-secondary" onclick="closeTable()">Close Table</button>
              </div>
            <!-- </div> -->
            <div class="col-12 mt-4" style="overflow:auto;">
              <div class="">

                    <table id="tabel" class="table table-bordered table-striped"   >
                      <!-- <div class="row mt-6">
                        <div class="col-12 text-left font-weight-bold">
                          LAPORAN PEMASUKAN BARANG PER DOKUMEN PABEAN
                        </div>
                      </div>
                      <div class="row">
                        <div class="col-12 text-left font-weight-bold">
                          KAWASAN BERIKAT PT. PEI HAI INTERNATIONAL WIRATAMA INDONESIA
                        </div>
                      </div>
                      <div class="row">
                        <div class="col-12 text-left font-weight-bold">
                          LAPORAN PEMASUKAN BARANG PER DOKUMEN PABEAN
                        </div>
                      </div>
                      <div class="row mb-4">
                        <div class="col-12 text-left font-weight-bold">
                          PERIODE:
                        </div>
                      </div> -->
                      <thead class="text-left" >
                        <tr>
                          <th colspan="13"  style="text-align: left; font-weight: bold;">LAPORAN PEMASUKAN BARANG PER DOKUMEN PABEAN <br/> KAWASAN BERIKAT PT. PEI HAI INTERNATIONAL WIRATAMA INDONESIA<br/> LAPORAN PEMASUKAN BARANG PER DOKUMEN PABEAN</th>
                        </tr>
                        <!-- <tr>
                          <th colspan="13"  style="text-align: left; font-weight: bold;">KAWASAN BERIKAT PT. PEI HAI INTERNATIONAL WIRATAMA INDONESIA</th>
                        </tr>
                        <tr>
                          <th colspan="13"  style="text-align: left; font-weight: bold;">LAPORAN PEMASUKAN BARANG PER DOKUMEN PABEAN</th>
                        </tr> -->
                        <tr id="periodeTable">
                          <th colspan="13"  style="text-align: left; font-weight: bold;">PERIODE:</th>
                        </tr>
                        <tr>
                          <th colspan="13"></th>
                        </tr>
                        <tr style="height: 45px; padding: 20px; " class="text-center bg-dark text-light">
                          <th scope="col" style="border: 1px solid black;">No</th>
                          <th scope="col" style="border: 1px solid black;">Jenis</th>
                          <th colspan="2" scope="col" style="border: 1px solid black;">Dokumen Pabean</th>
                          <th colspan="2" scope="col" style="border: 1px solid black;">Bukti Penerimaan Barang</th>
                          <th scope="col" style="border: 1px solid black;">Pemasok/Pengirim</th>
                          <th scope="col" style="border: 1px solid black;">Kode Barang</th>
                          <th scope="col" style="border: 1px solid black;">Nama Barang</th>
                          <th scope="col" style="border: 1px solid black;">Sat</th>
                          <th scope="col" style="border: 1px solid black;">Jumlah</th>
                          <th scope="col" style="border: 1px solid black;">Nilai Barang</th>
                          <th scope="col" style="border: 1px solid black;">Tanggal Input</th>

                        </tr>
                        <tr style="padding: 0px; margin: 0px; height: 18px; text-align: center;" class="text-center">

                          <th style="padding: 0px; margin: 0px; border: 1px solid black;"></th>
                          <th style="padding: 0px; margin: 0px; border: 1px solid black;"></th>

                          <th style="padding: 0px; margin: 0px; border: 1px solid black;">Nomor</th>
                          <th style="padding: 0px; margin: 0px; border: 1px solid black;">Tanggal</th>
                          <th style="padding: 0px; margin: 0px; border: 1px solid black;">Nomor</th>
                          <th style="padding: 0px; margin: 0px; border: 1px solid black;">Tanggal</th>
                          <th style="padding: 0px; margin: 0px; border: 1px solid black;"></th>
                          <th style="padding: 0px; margin: 0px; border: 1px solid black;"></th>
                          <th style="padding: 0px; margin: 0px; border: 1px solid black;"></th>
                          <th style="padding: 0px; margin: 0px; border: 1px solid black;"></th>
                          <th style="padding: 0px; margin: 0px; border: 1px solid black;"></th>
                          <th style="padding: 0px; margin: 0px; border: 1px solid black;"></th>
                          <th style="padding: 0px; margin: 0px; border: 1px solid black;"></th>

                        </tr>
                      </thead>

                      <!-- <thead id="tabel_data" style="height: 5px;"  class="text-center table-bordered table-striped" >
                        <tr style="padding: 0px; margin: 0px; height: 12px;">

                          <th style="padding: 0px; margin: 0px;"></th>
                          <th style="padding: 0px; margin: 0px;"></th>

                          <th style="padding: 0px; margin: 0px;">Nomor</th>
                          <th style="padding: 0px; margin: 0px;">Tanggal</th>
                          <th style="padding: 0px; margin: 0px;">Nomor</th>
                          <th style="padding: 0px; margin: 0px;">Tanggal</th>
                          <th style="padding: 0px; margin: 0px;"></th>
                          <th style="padding: 0px; margin: 0px;"></th>
                          <th style="padding: 0px; margin: 0px;"></th>
                          <th style="padding: 0px; margin: 0px;"></th>
                          <th style="padding: 0px; margin: 0px;"></th>
                          <th style="padding: 0px; margin: 0px;"></th>

                      </tr>
                    </thead> -->
                      <tbody id="tabel_data" class="text-center"  style="border: 1px solid black; text-align: center;">
                        <tr style="text-align: center">

                          <!-- <td style="border: 1px solid black;">1</td>
                          <td style="border: 1px solid black;">BC 2.6.2</td>

                          <td style="border: 1px solid black;">00703</td>
                          <td style="border: 1px solid black;">03/04/2023</td>
                          <td style="border: 1px solid black;">LPB/00/00/NGS0001</td>
                          <td style="border: 1px solid black;">03/04/2023</td>
                          <td style="border: 1px solid black;">PT. PEI HAI WIRATAMA IND</td>
                          <td style="border: 1px solid black;">PJTAFG230009981</td>
                          <td style="border: 1px solid black;">KOMPONEN UPPER YANG SUDAH DI PLONG</td>
                          <td style="border: 1px solid black;">SAT</td>
                          <td style="border: 1px solid black;">72.00</td>
                          <td style="border: 1px solid black;">12.000.000,00</td>
                          <td style="border: 1px solid black;">04-04-2023</td> -->

                          <td colspan=13 style="border: 1px solid black;">Tidak ada data ditemukan</td>


                      </tr>
                      </tbody>


                    </table>
              </div>
            </div>
          </div>
        </div>
</div>


<!-- start modal add -->
<div class="modal fade" id="form" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered"  role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">Add</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <!-- <h1>Tes Modal</h1> -->

        <div class="container-fluid">
          <input type="hidden" name="noUrut" id="input_add_noUrut" value="" />

            <div class="row">
              <div class="col-3 text-left">
                <div class="form-group text-left">
                  <label class="text-left">Perkiraan</label>
                </div>
              </div>
              <div class="col-3">
                <div class="form-group">
                  <input type="text" class="form-control" id="input_add_perkiraan" placeholder="Perkiraan">
                </div>
              </div>
              <div class="col-2 ">
                <div class="form-group text-center">
                  <label class="text-left">PPN</label>
                </div>
              </div>
              <div class="col-4">
                <div class="form-group">
                  <select id="input_add_isppn" class="form-control form-select-lg mb-3" aria-label=".form-select-lg example">
                    <option value=0>False</option>
                    <option value=1>True</option>
                  </select>
                </div>
              </div>



            </div>

          <div class="row">
            <div class="col-3">
              <div class="form-group">
                <label>Keterangan</label>
              </div>
            </div>
            <div class="col-9">
              <div class="form-group">
                <input type="text" class="form-control" id="input_add_keterangan" placeholder="Keterangan">
              </div>
            </div>


          </div>

          <div class="row">
            <div class="col-3">
              <div class="form-group">
                <label>Kelompok</label>
              </div>
            </div>
            <div class="col-3">
              <div class="form-group">
                <select id="input_add_kelompok" class="form-control form-select-lg mb-3" aria-label=".form-select-lg example">
                  <option value=0 selected >Aktiva</option>
                  <option value=1 >Kewajiban</option>
                  <option value=2 >Modal</option>
                  <option value=3 >Pendapatan</option>
                  <option value=4 >Biaya</option>
                </select>
              </div>
            </div>
            <div class="col-2">
              <div class="form-group text-center">
                <label>Tipe</label>
              </div>
            </div>
            <div class="col-4">
              <div class="form-group">
                <select id="input_add_tipe" class="form-control form-select-lg mb-3" aria-label=".form-select-lg example">
                  <option value=0 >General</option>
                  <option value=1 >Detail</option>
                </select>
              </div>
            </div>

          </div>

          <div class="row">
            <div class="col-3">
              <div class="form-group">
                <label>Debet/Kredit</label>
              </div>
            </div>
            <div class="col-3">
              <div class="form-group">
                <select id="input_add_debetkredit" class="form-control form-select-lg mb-3" aria-label=".form-select-lg example">
                  <option value=0 >Debet</option>
                  <option value=1 >Kredit</option>
                </select>
              </div>
            </div>
            <div class="col-2">
              <div class="form-group text-center">
                <label>Valas</label>
              </div>
            </div>
            <div class="col-4">
              <div class="form-group">
                <select id="input_add_valas" class="form-control form-select-lg mb-3" aria-label=".form-select-lg example">
                  <option value="IDR" >IDR</option>
                  <option value="SGD" >SGD</option>
                </select>
              </div>
            </div>

          </div>
          <div class="row">
            <div class="col-3">
              <div class="form-group">
                <label>Status</label>
              </div>
            </div>
            <div class="col-3">
              <div class="form-group">
                <select id="input_add_status" class="form-control form-select-lg mb-3" aria-label=".form-select-lg example">
                  <option value=0 >Active</option>
                  <option value=1 >Inactive</option>
                </select>
              </div>
            </div>

            <div class="col-2">
              <div class="form-group text-center">
                <label>Simbol</label>
              </div>
            </div>
            <div class="col-4">
              <div class="form-group">
                <input type="text" class="form-control" id="input_add_simbol" placeholder="Simbol">
              </div>
            </div>

          </div>





    </div>
  </div>
  <div class="modal-footer">
    <button type="button" class="btn btn-secondary" data-dismiss="modal" >Batal</button>
    <button type="button" class="btn btn-primary" onclick="submitAdd()">Submit</button>
  </div>
</div>
</div>
</div>
<!-- End modal add-->












@endsection

@section('js')
<script type="text/javascript">

let noUrutTable = 1
let nomor = ''

function closeTable () {

  document.getElementById("showTableReport").style.display = "none"
}

function makeTable () {
  noUrutTable = 1
  console.log('makeTable')
  let date1 = $("#inputDate1").val();
  let date2 = $("#inputDate2").val();
  let input1 = $("#inputReport1").val();
  let input2 = $("#inputReport2").val();
  let input3 = $("#inputReport3").val();


  // let _token = $("#_token").val();
  // console.log(_token)

  console.log(date1)
  console.log(date2)
  console.log(input1)
  console.log(input2)
  console.log(input3)

  let periodeTable = `<th colspan="13"  style="text-align: left; font-weight: bold;">PERIODE: ${date1} s/d ${date2}</th>`
  //
  document.getElementById("showTableReport").style.display = "block"
  $.ajax({
    url: "{!! url('spReportTes') !!}",
    type: "get",
    async: false,
    data: {
      // _token : 'TJynZ1YRlAFnp0QEf3rzza6bwEzTxEI0RBr7qPK9',
      date1,
      date2,
      input1,
      input2,
      input3
    },
    success: function(res) {
      console.log(res)
      let rowTable = ""






      res.forEach((item, i) => {
        // console.log(item)
        // console.log(item.BuktiLPB)
        //
        let dateDokumen = new Date(item.TanggalDokumen);
        let dayDokumen = ("0" + dateDokumen.getDate()).slice(-2);
        let monthDokumen = ("0" + (dateDokumen.getMonth() + 1)).slice(-2);
        let dateShowDokumen = dateDokumen.getFullYear()+"-"+(monthDokumen)+"-"+(dayDokumen) ;
        //
        let dateLPB = new Date(item.TanggalLPB);
        let dayLPB = ("0" + dateLPB.getDate()).slice(-2);
        let monthLPB = ("0" + (dateLPB.getMonth() + 1)).slice(-2);
        let dateShowLPB = dateLPB.getFullYear()+"-"+(monthLPB)+"-"+(dayLPB) ;
        //
        let dateInput = new Date(item.TglInput);
        let dayInput = ("0" + dateInput.getDate()).slice(-2);
        let monthInput = ("0" + (dateInput.getMonth() + 1)).slice(-2);
        let dateShowInput = dateInput.getFullYear()+"-"+(monthInput)+"-"+(dayInput) ;

        if (nomor == item.NomorDokumen) {
          rowTable += `<tr style="text-align: center">

            <td style="border: 1px solid black;"></td>
            <td style="border: 1px solid black;"></td>

            <td style="border: 1px solid black;">${item.NomorDokumen}</td>
            <td style="border: 1px solid black;">${dateShowDokumen}</td>
            <td style="border: 1px solid black;">${item.BuktiLPB}</td>
            <td style="border: 1px solid black;">${dateShowLPB}</td>
            <td style="border: 1px solid black;">${item.NamaSupp}</td>
            <td style="border: 1px solid black;">${item.KodeBrg}</td>
            <td style="border: 1px solid black;">${item.NamaBrg}</td>
            <td style="border: 1px solid black;">${item.Satuan}</td>
            <td style="border: 1px solid black;">${item.Jumlah}</td>
            <td style="border: 1px solid black;">${item.NilaiBrg}</td>
            <td style="border: 1px solid black;">${dateShowInput}</td>


          </tr>`
        } else {
          if (noUrutTable !== 1) {
            rowTable += `<tr style="text-align: center">

              <td style="border: 1px solid black;"></td>
              <td style="border: 1px solid black;"></td>

              <td style="border: 1px solid black;"></td>
              <td style="border: 1px solid black;"></td>
              <td style="border: 1px solid black;"></td>
              <td style="border: 1px solid black;"></td>
              <td style="border: 1px solid black;"></td>
              <td style="border: 1px solid black;"></td>
              <td style="border: 1px solid black;"></td>
              <td style="border: 1px solid black;"></td>
              <td style="border: 1px solid black;"></td>
              <td style="border: 1px solid black;"></td>
              <td style="border: 1px solid black;"></td>


            </tr>`
          }
          rowTable += `<tr style="text-align: center">

            <td style="border: 1px solid black;">${noUrutTable}</td>
            <td style="border: 1px solid black;">${item.JenisDokumen}</td>

            <td style="border: 1px solid black;">${item.NomorDokumen}</td>
            <td style="border: 1px solid black;">${dateShowDokumen}</td>
            <td style="border: 1px solid black;">${item.BuktiLPB}</td>
            <td style="border: 1px solid black;">${dateShowLPB}</td>
            <td style="border: 1px solid black;">${item.NamaSupp}</td>
            <td style="border: 1px solid black;">${item.KodeBrg}</td>
            <td style="border: 1px solid black;">${item.NamaBrg}</td>
            <td style="border: 1px solid black;">${item.Satuan}</td>
            <td style="border: 1px solid black;">${item.Jumlah}</td>
            <td style="border: 1px solid black;">${item.NilaiBrg}</td>
            <td style="border: 1px solid black;">${dateShowInput}</td>


          </tr>`

          noUrutTable ++
        }
        nomor = item.NomorDokumen


      });

      if(!res.length) {
        rowTable = `<tr style="text-align: center">

          <td colspan=13 style="border: 1px solid black;">Tidak ada data ditemukan</td>



        </tr>`
      }
      document.getElementById("periodeTable").innerHTML = periodeTable

      document.getElementById("tabel_data").innerHTML = rowTable
  }})
}

function exportTableToExcel(tableID, filename = '') {

  // makeTable()
  // return
  var downloadLink;
  var dataType = 'application/vnd.ms-excel';
  var tableSelect = document.getElementById(tableID);
  var tableHTML = tableSelect.outerHTML.replace(/ /g, '%20');

  // Specify file name
  filename = filename?filename+'.xls':'excel_data.xls';

  // Create download link element
  downloadLink = document.createElement("a");

  document.body.appendChild(downloadLink);

  if(navigator.msSaveOrOpenBlob){
      var blob = new Blob(['\ufeff', tableHTML], {
          type: dataType
      });
      navigator.msSaveOrOpenBlob( blob, filename);
  }else{
      // Create a link to the file
      downloadLink.href = 'data:' + dataType + ', ' + tableHTML;

      // Setting the file name
      downloadLink.download = filename;

      //triggering the function
      downloadLink.click();
  }
}

</script>




@endsection
