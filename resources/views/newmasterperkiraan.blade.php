@extends('newmaster')
@section('buttons')

@endsection
@section('content')
<div class="container-fluid">

  <!-- <div id="qrcode"></div> -->
  <div class="row">
    <div class="col-6 text-left">
      <h1>Master Perkiraan</h1>
    </div>
    <div class="col-6 text-right">
      <button type="button" class="btn btn-primary btn-lg " style="height: 60px; " onclick="buttonAdd()"  >Add Perkiraan</button>
    </div>
  </div>
<!-- <button onclick="loadAll()">tes</button> -->
</div>

<div id="printContainer" style="display:none">

</div>
<div id="contentContainer" class="container-fluid">
  <input type="hidden" id="periode_tahun" value="{!! $periode->tahun !!}" />
  <input type="hidden" id="periode_bulan" value="{!! $periode->bulan !!}" />
  <input type="hidden" name="_token" id="_token" value="{!! csrf_token() !!}" />
          <div class="row mt-4">
              <!-- <div class="col-12 text-right">
                  <button type="button" class="btn btn-primary btn-lg " style="height: 60px; " onclick="buttonAdd()"  >Add Koreksi Stock Gudang</button>
              </div> -->
          </div>
          <div class="row mt-3">
            <div class="col-12" style="overflow:auto;">
              <div class="">

                    <table id="tabel" class="table table-bordered table-striped"  >
                      <thead class="text-center">
                        <tr>
                          <th scope="col">Perkiraan</th>
                          <th scope="col">Keterangan</th>
                          <th scope="col">Kelompok</th>
                          <th scope="col">Tipe</th>
                          <th scope="col">Transaksi</th>
                          <th scope="col">Valas</th>
                          <th scope="col">Simbol</th>
                          <th scope="col">PPN</th>
                          <th scope="col">Status</th>
                          <th scope="col">Actions</th>

                        </tr>
                      </thead>


                      <tbody id="tabel_data" class="text-right" >
                        @for ($i = 0; $i < count($listData); $i++)
                        <tr >

                          <td>{{ $listData[$i]->Perkiraan }}</td>
                          <td>{{ $listData[$i]->Keterangan }}</td>

                          <td>{{ $listData[$i]->mKelompok }}</td>
                          <!-- <td>{{ $listData[$i]->Kelompok }}</td> -->
                          <td>{{ $listData[$i]->mTipe }}</td>
                          <td>{{ $listData[$i]->mDK }}</td>
                          <td>{{ $listData[$i]->Valas }}</td>
                          <td>{{ $listData[$i]->Simbol }}</td>
                          <!-- <td>{{ $listData[$i]->IsPPN }}</td> -->
                          @if ($listData[$i]->IsPPN == 0)
                            <td class="text-danger text-center"><i class="bi bi-x" style="-webkit-text-stroke-width: 2px;"></i></td>
                          @elseif ($listData[$i]->IsPPN == 1)
                            <td class="text-success text-center"><i class="bi bi-check2" style="-webkit-text-stroke-width: 2px;"></i></td>
                          @endif


                          <td>{{ $listData[$i]->Status }}</td>
                            <td class="text-center">
                              <!-- <button class="btn btn-warning btn-sm" type="button" onclick="" ><i class="bi bi-info-lg"></i></button> -->
                              <button class="btn btn-success btn-sm" type="button" onclick="buttonEdit('{{ $listData[$i]->Perkiraan }}')"><i class="bi bi-pen"></i></button>
                              <button class="btn btn-danger btn-sm" type="button" onclick="buttonDelete('{{ $listData[$i]->Perkiraan }}')"><i class="bi bi-trash"></i></button>
                            </td>
                      </tr>
                      @endfor
                      </tbody>


                    </table>
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

            <!-- <div class="col-2 text-right">
              <div class="form-group">
            <button onclick="resetScannerKode2()" class="btn btn-success btn-sm text-right"><i class="bi bi-arrow-clockwise"></i></button>
            </div>
            </div> -->
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
          <!-- <div class="row">
            <div class="col-3">
              <div class="form-group">
                <label>Tipe</label>
              </div>
            </div>
            <div class="col-3">
              <div class="form-group">
                <input type="text" class="form-control" id="input_add_kode2" placeholder="Barcode Lokasi" onkeypress="enterScannerKode2(event)">
              </div>
            </div>

          </div> -->
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



        <!-- <div class="container-fluid">
          <div class="row ">
            <div class="col-md-12 text-right">
            <button type="button" class="btn btn-primary" onclick="buttonAddItem()" class="btn btn-secondary"  >Add Item</button>
        </div>

        </div>



        </div> -->

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



<!-- start modal edit -->
<div class="modal fade" id="formEdit" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered"  role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">Edit Perkiraan</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <!-- <h1>Tes Modal</h1> -->

        <div class="container-fluid">
          <!-- <input type="hidden" name="noUrut" id="input_add_noUrut" value="" /> -->

            <div class="row">
              <div class="col-3 text-left">
                <div class="form-group text-left">
                  <label class="text-left">Perkiraan</label>
                </div>
              </div>
              <div class="col-3">
                <div class="form-group">
                  <input type="text" class="form-control" id="input_edit_perkiraan" placeholder="Perkiraan" disabled>
                </div>
              </div>
              <div class="col-2 ">
                <div class="form-group text-center">
                  <label class="text-left">PPN</label>
                </div>
              </div>
              <div class="col-4">
                <div class="form-group">
                  <select id="input_edit_isppn" class="form-control form-select-lg mb-3" aria-label=".form-select-lg example">
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
                <input type="text" class="form-control" id="input_edit_keterangan" placeholder="Keterangan">
              </div>
            </div>

            <!-- <div class="col-2 text-right">
              <div class="form-group">
            <button onclick="resetScannerKode2()" class="btn btn-success btn-sm text-right"><i class="bi bi-arrow-clockwise"></i></button>
            </div>
            </div> -->
          </div>

          <div class="row">
            <div class="col-3">
              <div class="form-group">
                <label>Kelompok</label>
              </div>
            </div>
            <div class="col-3">
              <div class="form-group">
                <select id="input_edit_kelompok" class="form-control form-select-lg mb-3" aria-label=".form-select-lg example">
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
                <select id="input_edit_tipe" class="form-control form-select-lg mb-3" aria-label=".form-select-lg example">
                  <option value=0 >General</option>
                  <option value=1 >Detail</option>
                </select>
              </div>
            </div>

          </div>
          <!-- <div class="row">
            <div class="col-3">
              <div class="form-group">
                <label>Tipe</label>
              </div>
            </div>
            <div class="col-3">
              <div class="form-group">
                <input type="text" class="form-control" id="input_edit_kode2" placeholder="Barcode Lokasi" onkeypress="enterScannerKode2(event)">
              </div>
            </div>

          </div> -->
          <div class="row">
            <div class="col-3">
              <div class="form-group">
                <label>Debet/Kredit</label>
              </div>
            </div>
            <div class="col-3">
              <div class="form-group">
                <select id="input_edit_debetkredit" class="form-control form-select-lg mb-3" aria-label=".form-select-lg example">
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
                <select id="input_edit_valas" class="form-control form-select-lg mb-3" aria-label=".form-select-lg example">
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
                <select id="input_edit_status" class="form-control form-select-lg mb-3" aria-label=".form-select-lg example">
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
                <input type="text" class="form-control" id="input_edit_simbol" placeholder="Simbol">
              </div>
            </div>

          </div>



        <!-- <div class="container-fluid">
          <div class="row ">
            <div class="col-md-12 text-right">
            <button type="button" class="btn btn-primary" onclick="buttonAddItem()" class="btn btn-secondary"  >Add Item</button>
        </div>

        </div>



        </div> -->

    </div>
  </div>
  <div class="modal-footer">
    <button type="button" class="btn btn-secondary" data-dismiss="modal" >Batal</button>
    <button type="button" class="btn btn-primary" onclick="submitEdit()">Submit</button>
  </div>
</div>
</div>
</div>
<!-- End modal edit-->










@endsection

@section('js')
<script type="text/javascript">

let dataRefresh = []


$(document).ready(function(){
      $("#tabel").DataTable({
        "lengthChange": false,
          "paging": false ,
        //    "columnDefs": [
        // { "type": "date", "targets": [1] },
        // {  "className": "text-center", "targets": [3] },
      // ]
    });



});

  function buttonAdd () {


        $("#form").modal('toggle')

  }

  function loadAll () {
    console.log('asd')
    let _token = $("#_token").val();
    $('#tabel').DataTable().destroy();

    $.ajax({
      url: "{!! url('newperkiraanloadall') !!}",
      type: "get",
      async: false,
      data: {
        _token : _token,
      },
      success: function(res) {
        console.log(res)
        dataRefresh = res
    }})

    let rowTable = ""
    dataRefresh.forEach((item, i) => {
      let temp = ""
      if (item.IsPPN == 0) {
        temp = '<td class="text-danger text-center"><i class="bi bi-x" style="-webkit-text-stroke-width: 2px;"></i></td>'
      } else {
        temp = '<td class="text-success text-center"><i class="bi bi-check2" style="-webkit-text-stroke-width: 2px;"></i></td>'
      }
      rowTable += `<tr>
      <td>${item.Perkiraan}</td>
      <td>${item.Keterangan}</td>
      <td>${item.mKelompok}</td>
      <td>${item.mTipe}</td>
      <td>${item.mDK}</td>
      <td>${item.Valas}</td>
      <td>${item.Simbol}</td>` + temp +
      `<td>${item.Status}</td>
      <td class="text-center">
        <button class="btn btn-success btn-sm" type="button" onclick="buttonEdit('${item.Perkiraan}')"><i class="bi bi-pen"></i></button>
        <button class="btn btn-danger btn-sm" type="button" onclick="buttonDelete('${item.Perkiraan}')"><i class="bi bi-trash"></i></button>
      </td>
      </tr>`
    });





    document.getElementById("tabel_data").innerHTML = rowTable
    $("#tabel").DataTable({
      "lengthChange": false,
        "paging": false ,

    });

  }

  function buttonEdit (perkiraan) {

      console.log(perkiraan)
        let _token = $("#_token").val();
      console.log('a')
        $.ajax({
          url: "{!! url('newdetailperkiraan') !!}",
          type: "post",
          async: false,
          data: {
            _token : _token,
            perkiraan
          },
          success: function(res) {
            console.log('tes')
            console.log(res ,'!')
            document.getElementById("input_edit_perkiraan").value = res.Perkiraan
            document.getElementById("input_edit_keterangan").value = res.Keterangan


            document.getElementById("input_edit_isppn").value = Number(res.IsPPN)
            document.getElementById("input_edit_kelompok").value = res.Kelompok
            document.getElementById("input_edit_valas").value = res.Valas
            document.getElementById("input_edit_tipe").value = res.Tipe
            document.getElementById("input_edit_simbol").value = res.Simbol
            document.getElementById("input_edit_debetkredit").value = res.DK

            let tempStatus = 1
            if (res.Status === "Aktif") {
              tempStatus = 0
            }
            document.getElementById("input_edit_status").value = tempStatus

          }})




        $("#formEdit").modal('toggle')

  }

  function submitEdit () {
    let _token = $("#_token").val();
    let choice = "U"
    let perkiraan = $("#input_edit_perkiraan").val();
    let keterangan = $("#input_edit_keterangan").val();
    let kelompok = $("#input_edit_kelompok").val();
    let tipe = $("#input_edit_tipe").val();
    let valas = $("#input_edit_valas").val();
    let debetkredit = $("#input_edit_debetkredit").val();
    let neraca = "tes"
    let simbol = $("#input_edit_simbol").val();
    let isppn = $("#input_edit_isppn").val();
    let lokasi = 0
    let isaktif = $("#input_edit_status").val();

    // console.log('perkiraan' ,perkiraan)
    // console.log('isppn' ,isppn)
    // console.log('keterangan' ,keterangan)
    // console.log('kelompok' ,kelompok)
    // console.log('tipe' ,tipe)
    // console.log('debetkredit' ,debetkredit)
    // console.log('valas' ,valas)
    // console.log('status' ,status)
    // console.log('simbol' ,simbol)
    // console.log('isaktif' ,isaktif)


    $.ajax({
      url: "{!! url('newaddperkiraan') !!}",
      type: "post",
      async: false,
      data: {
        _token : _token,
        choice ,
        perkiraan ,
        keterangan ,
        kelompok ,
        tipe ,
        valas ,
        debetkredit ,
        neraca ,
        simbol ,
        isppn ,
        lokasi ,
        isaktif
      },
      success: function(res) {
        console.log(res ,'!')
        $("#formEdit").modal('toggle')
        alertify.success("Perkiraan telah diedit");
        loadAll ()
      }})
  }


  function submitAdd() {

    console.log('asd')
    let _token = $("#_token").val();
    let choice = "I"
    let perkiraan = $("#input_add_perkiraan").val();
    let keterangan = $("#input_add_keterangan").val();
    let kelompok = $("#input_add_kelompok").val();
    let tipe = $("#input_add_tipe").val();
    let valas = $("#input_add_valas").val();
    let debetkredit = $("#input_add_debetkredit").val();
    let neraca = "tes"
    let simbol = $("#input_add_simbol").val();
    let isppn = $("#input_add_isppn").val();
    let lokasi = 0
    let isaktif = $("#input_add_status").val();
    if (!perkiraan) {
      alertify.warning("Perkiraan tidak boleh kosong");
      return
    }
    // console.log('perkiraan' ,perkiraan)
    // console.log('isppn' ,isppn)
    // console.log('keterangan' ,keterangan)
    // console.log('kelompok' ,kelompok)
    // console.log('tipe' ,tipe)
    // console.log('debetkredit' ,debetkredit)
    // console.log('valas' ,valas)
    // console.log('status' ,status)
    // console.log('simbol' ,simbol)
    // console.log('isaktif' ,isaktif)


    $.ajax({
      url: "{!! url('newaddperkiraan') !!}",
      type: "post",
      async: false,
      data: {
        _token : _token,
        choice ,
        perkiraan ,
        keterangan ,
        kelompok ,
        tipe ,
        valas ,
        debetkredit ,
        neraca ,
        simbol ,
        isppn ,
        lokasi ,
        isaktif
      },
      success: function(res) {
        console.log(res ,'!')
        if (res == 0) {
          alertify.warning("Perkiraan sudah ada");
        } else {
          alertify.success("Perkiraan telah ditambah");
          loadAll ()
          $("#form").modal('toggle')
        }
      }})
  }

  function buttonDelete(perkiraan) {



      let _token = $("#_token").val();

    alertify.confirm('Hapus Item', 'Apakah yakin ingin menghapus perkiraan ' + perkiraan + ' ?',
        function() {
          console.log('yes')
          let choice = "D"

          $.ajax({
            url: "{!! url('newaddperkiraan') !!}",
            type: "post",
            async: false,
            data: {
              _token : _token,
              choice ,
              perkiraan ,
              keterangan: '' ,
              kelompok: 0,
              tipe :0,
              valas :'IDR',
              debetkredit: 0 ,
              neraca: 'tes' ,
              simbol: 'tes' ,
              isppn: 0 ,
              lokasi: 0 ,
              isaktif: 0
            },
            success: function(res) {
              console.log(res ,'!')
              alertify.success("Perkiraan telah didelete");
              loadAll ()
            }})
        }
      ,function(){
        console.log('no')
      });
  }


</script>




@endsection
