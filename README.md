# Formal Analysis of an Auxiliary Algorithm for MAS-based Protection of Power Distribution Networks
 
In this work the DTMC based formal models of digital relay agents equipped with the protection and signal dispatching functionalities,circuit breakers and DGs are developed. These models are used for analyzing the MAS-based protection schemes. The proposed methodology uses the probabilistic model checker PRISM to verify the reliability and safety properties. 

# Case Study: Single Line Diagram of Test System [1]
![single line diagram](https://github.com/SobiaatNUST/TEST/blob/main/Assets/SLDG_Final.png)

# Probabilistic Analysis Results 
Table below shows the quantitive verification results obtained using two algorithms.

 <table>
    <tr>
       <th colspan ="1"> </th>
        <th colspan ="4"> Main Algorithm</th>
        <th colspan="2"> Auxiliary Algorithm</th>
    </tr>
  <tr>
        <td>Fault Zones</td>
     <td>Isolation Success </td>
        <td>Isolation Failure</td>
        <td>False Tripping</td>
        <td>System Under Risk</td>
        <td>Isolation Success</td>
        <td>Isolation Failure</td>
    </tr>
    <tr>
        <td>Z1</td>
     <td>0.6595 </td>
        <td>0.0406</td>
        <td>0.2430</td>
        <td>0.0569</td>
        <td>0.9596</td>
        <td>0.0403</td>
    </tr>
    <tr>
        <td>Z2</td>
     <td>0.6593</td>
        <td>0.0406</td>
        <td>0.2430</td>
        <td>0.0569</td>
        <td>0.9596</td>
        <td>0.0403</td>
    </tr>
     <tr>
        <td>Z3</td>
     <td>0.6593</td>
        <td>0.0406</td>
        <td>0.2430</td>
        <td>0.0569</td>
        <td>0.9596</td>
        <td>0.0403</td>
    </tr>
       <tr>
        <td>Z4</td>
     <td>0.6591</td>
        <td>0.0407</td>
        <td>0.2430</td>
        <td>0.0569</td>
        <td>0.9565</td>
        <td>0.0434</td>
    </tr>
</table>

For more information, please feel free to contact sashraf.dphd19seecs@seecs.edu.pk

[1]  B. Fani, E. Abbaspour, and A. Karami-Horestani
    “A fault-clearing algorithm supporting the mas-based protection schemes,”
    International Journal of Electrical Power & Energy Systems, vol. 103, pp. 257–266,2018.
