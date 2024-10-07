# Formal Analysis of an Auxiliary Algorithm for MAS-based Protection of Power Distribution Networks
 
In this work the DTMC based formal models of digital relay agents equipped with the protection and signal dispatching functionalities,circuit breakers and DGs are developed. These models are used for analyzing the MAS-based protection schemes. The proposed methodology uses the probabilistic model checker PRISM to verify the reliability and safety properties. 

# Test System: Single Line Diagram of Test System [1]
![single line diagram](https://github.com/SobiaatNUST/Quantitative-Analysis-of-MAS-Based-Protection-Systems/blob/main/SLDG_Final.png)

# Probabilistic Analysis Results 
Table below shows the quantitive verification results obtained using Auxiliary algorithm Part A and Part B.

 <table>
    <tr>
       <th colspan ="1"> </th>
        <th colspan ="4"> Auxiliary Algorithm Part A</th>
        <th colspan="4"> Auxiliary Algorithm Part B</th>
    </tr>
  <tr>
        <td>Fault Zones</td>
     <td>Isolation Success </td>
        <td>Isolation Failure</td>
        <td>False Trip</td>
        <td>Risk</td>
        <td>Isolation Success</td>
        <td>Isolation Failure</td>
         <td>False Trip</td>
        <td>Risk</td>
    </tr>
    <tr>
        <td>Z1</td>
     <td>0.9625 </td>
        <td>0.0344</td>
        <td>0.0</td>
        <td>0.0031</td>
        <td>0.8966</td>
        <td>0.0344</td>
        <td>0.0659</td>
        <td>0.0031</td>
    </tr>
    <tr>
        <td>Z2</td>
       <td>0.9625 </td>
        <td>0.0344</td>
        <td>0.0</td>
        <td>0.0031</td>
        <td>0.8966</td>
        <td>0.0344</td>
        <td>0.0659</td>
        <td>0.0031</td>
    </tr>
     <tr>
        <td>Z3</td>
    <td>0.9625 </td>
        <td>0.0344</td>
        <td>0.0</td>
        <td>0.0031</td>
        <td>0.8966</td>
        <td>0.0344</td>
        <td>0.0659</td>
        <td>0.0031</td>
    </tr>
       <tr>
        <td>Z4</td>
       <td>0.9586 </td>
        <td>0.0379</td>
        <td>0.0</td>
        <td>0.0035</td>
        <td>0.8964</td>
        <td>0.0370</td>
        <td>0.0632</td>
        <td>0.0034</td>
    </tr>
</table>
     
  # Probabilistic Analysis Results 
Table below shows the quantitive verification results obtained using Traditional Algorithm.
        
 <table>
       <tr>
       <th colspan ="1"> </th>
        <th colspan ="4"> Traditional Algorithm </th>
   </tr>
      <tr>
        <td>Fault Zones</td>
     <td>Isolation Success </td>
        <td>Isolation Failure</td>
        <td>False Trip</td>
        <td>Risk</td>
   </tr>
      <tr>
        <td>Z1</td>
      <td>0.6595 </td>
        <td>0.0406</td>
        <td>0.2430</td>
        <td>0.0569</td>
   </tr>
     <tr>
        <td>Z2</td>
      <td>0.6593 </td>
        <td>0.0406</td>
        <td>0.2430</td>
        <td>0.0569</td>
   </tr>  
       <tr>
        <td>Z3</td>
      <td>0.6593 </td>
        <td>0.0406</td>
        <td>0.2430</td>
        <td>0.0569</td>
   </tr>
     <tr>
        <td>Z4</td>
       <td>0.6591 </td>
        <td>0.0407</td>
        <td>0.2430</td>
        <td>0.0569</td>
  </tr>
 </table>
 For more information, please feel free to contact sashraf.dphd19seecs@seecs.edu.pk
 Report and Codes can be accessed [here](https://github.com/SobiaatNUST/Quantitative-Analysis-of-MAS-Based-Protection-Systems)
 

[1]  B. Fani, E. Abbaspour, and A. Karami-Horestani
    “A fault-clearing algorithm supporting the mas-based protection schemes,”
    International Journal of Electrical Power & Energy Systems, vol. 103, pp. 257–266,2018.
