
<tag-form>

  <h3>Create a new Tag</h3>  
  <form onsubmit={ save }>
  	<fieldset>
  		<label>Device name</label>
  		<input name="name" class="form-text" >
  	</fieldset>
  	
  	<fieldset>
  		<label>Device Brand</label>
  		<input name="brand" class="form-text" >
  	</fieldset>
  	
  	<fieldset>
  		<label>Storage Capacity</label>
  		<input name="storage" class="form-text" >
  		<p class="form-help">Enter only numbers</p>
  	</fieldset>
  	
  	<fieldset>
  		<label >Sale Price</label>
  		<input name="price" class="form-text" >
  		<p class="form-help">Enter only numbers</p>
  	</fieldset>
  	
  	<fieldset>
  		<label >Enter the IMEI/MEID</label>
  		<input name="upcimei" maxlength="11" class="form-text">
  		<p class="form-help">Or serial number</p>
  	</fieldset>
  	
  	<button>save and print</button>
  </form>			
  <p class={ visible: show }>{ tag.brand }</p>
  <p class={ visible: show }>{ tag.storage } GB</p>
  <p class={ visible: show }>${ tag.price }</p>
  <p class={ visible: show }>UPC-A</p>
  <div id='container' style="margin:30px;">
  <svg id='upcCode'></svg>
  
 	
		this.tag = {}
		this.show = true
		function upc (code) {
			var oddNumbers = 0;
			var evenNumbers = 0;
			var st = code.split('')
			for (n in st) {
				if (n % 2 == 0) {
					oddNumbers += parseInt(st[n]);
				} else {
					evenNumbers += parseInt(st[n]);
				}
			};
			
			var checksum = 10 - ((oddNumbers * 3 + evenNumbers) % 10)
			
			return code + checksum.toString()
		};
	  save(e) {
	  	this.tag.name = this.name.value
	  	this.tag.brand = this.brand.value
	  	this.tag.storage = this.storage.value
	  	this.tag.price = this.price.value
	  	var imei = upc(this.upcimei.value)
	  	generateBarcode(imei)
	  	this.show = !this.show
	  }
	  
	  function generateBarcode(u) {
	      var upc = u.split('');
	      // Break up the barcode. Used for writing the numbers underneath the bar code.
	      var ns = u.substring(0, 1); //Number System
	      var mc = u.substring(1, 6); //Manufactures Code
	      var pc = u.substring(6, 11); //Product Code
	      var cd = u.substring(11, 12); //Check Digit
	  
	      // Modules for barcodes
	      var sg = ["101"]; //Start and End Guards are 3 modules
	      var mg = ["01010"]; //Middle Guard is 5 modules
	      // Each number, 0 through 9, is 7 modules.
	      // Left side of the Middle Guard (manufactures code) is odd parity
	      var op = ["0001101", "0011001", "0010011", "0111101", "0100011", "0110001", "0101111", "0111011", "0110111", "0001011"];
	      // Right side of Middle Guard (product code) is even parity
	      var ep = ["1110010", "1100110", "1101100", "1000010", "1011100", "1001110", "1010000", "1000100", "1001000", "1110100"];
	  
	      // Loop through the first 6 digits of the barcode and find their corresponding modules in the odd parity array
	      upcOP = "";
	      var i = 0;
	      while (i <= 5) {
	          upcOP += op[upc[i]];
	          i++;
	      }
	  
	      // Loop through the last 6 digits of the barcode and find their corresponding modules in the even parity array
	      upcEP = "";
	      var i = 6;
	      while (i <= 11) {
	          upcEP += ep[upc[i]];
	          i++;
	      }
	  
	      // Create a string of all the modules including the guards
	      var data = sg + upcOP + mg + upcEP + sg;
	  
	      // Set height and width of the barcode modules
	      var height = 100,
	          barWidth = 2;
	  
	      // Sets scale range for barcode
	      var x = d3.scale.linear()
	          .domain([0, d3.max(data)]) // length
	      .range([0, height]); // height
	  
	      d3.select("#upcCode").remove(); //Clear the SVG container if a new upc code has been entered
	  
	      // Select container div and create new holder for the upc
	      var chart = d3.select("#container")
	          .append("svg:svg")
	          .attr("id", "upcCode")
	  
	      // Set the size of the upc holder
	      var chart = d3.select("#upcCode")
	          .attr("height", "130px")
	          .attr("width", barWidth * data.length + 40);
	  
	      // Draw the barcode
	      var bar = chart.selectAll("g")
	          .data(data)
	          .enter().append("g")
	          .attr("transform", function (d, i) {
	          return "translate(" + i * barWidth + ")";
	      })
	          ;
	  
	      bar.append("rect")
	          .attr("x",20)
	          .attr("height",function(d, i) { 
	            // Adjusts the height of the guard bars by looking at their index
	            if (i==0||i==2||i==46||i==48||i==92||i==94){return (d*100)} else {return(d*80)};
	          }) 
	          .attr("width", barWidth);
	  
	      // Write human readable numbers under the barcode
	      chart.append("g")
	          .append("text")
	          .attr("x", "1px")
	          .attr("y", "100px")
	          .style("font-size", "24px")
	          .style("font-family", "sans-serif")
	          .text(ns);
	  
	      chart.append("g")
	          .append("text")
	          .attr("x", "38px")
	          .attr("y", "100px")
	          .style("font-size", "24px")
	          .style("font-family", "sans-serif")
	          .text(mc);
	  
	      chart.append("g")
	          .append("text")
	          .attr("x", "128px")
	          .attr("y", "100px")
	          .style("font-size", "24px")
	          .style("font-family", "sans-serif")
	          .text(pc);
	  
	      chart.append("g")
	          .append("text")
	          .attr("x", "215px")
	          .attr("y", "100px")
	          .style("font-size", "24px")
	          .style("font-family", "sans-serif")
	          .text(cd);
	  };
	  
	 
</tag-form>

















