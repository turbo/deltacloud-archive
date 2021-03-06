---
site_name: Deltacloud API
title: Working with cURL
---

<br/>

<div class="row">

  <div class="span8">

    <h3 id="command">Working with cURL as a command line client</h3>

    <p> The <a href="http://curl.haxx.se/docs/">cURL documentation</a> is pretty comprehensive, but the following are some general points to remember for using cURL against Deltacloud. All the examples on this page assume the deltacloud server is running at localhost:3001: </p>

  <ul>
    <li>
      Credentials are specified with <strong> --user "name:password"  </strong>
    </li>
    <li>
      Request headers are specified with <strong> -H "header: value" </strong>. For the "Accept" header Deltacloud offers a convenient way of specifying the desired response format; you can include the <strong>"?format="</strong> parameter into the request URL rather than setting the Accept header
    </li>
    <li>
      HTTP verbs are specified with <strong>-X VERB</strong>
    </li>
    <li>
      The <strong> -i </strong> flag will show you the response headers and the <strong> -v </strong> flag will show you request and response headers as well as info about cURL activity:
      <pre>
curl -v -X DELETE --user "username:password" -H "Accept: application/xml" http://localhost:3001/api/keys/mykey
      </pre>
    </li>
  </ul>

  </div>

  <div class="span4">

    <ul class="nav nav-list well">
      <li class="nav-header">cURL as a deltacloud client</li>
      <li class="active"><a href="#instances">Work with instances</a></li>
      <li><a href="#images">Work with images</a></li>
      <li><a href="#hardware_profiles">Work with hardware profiles</a></li>
      <li><a href="#realms">Work with realms</a></li>
      <li><a href="#keys">Work with keys</a></li>
      <li><a href="#firewalls">Work with firewalls</a></li>
      <li><a href="#addresses">Work with addresses</a></li>
      <li><a href="#load_balancers">Work with load balancers</a></li>
      <li><a href="#buckets">Work with buckets</a></li>
      <li><a href="#storage_volumes">Work with storage volumes</a></li>
      <li><a href="#storage_snapshots">Work with storage snapshots</a></li>
    </ul>

  </div>
</div>

<hr/>

<h4 id="instances">Working with instances</h4>

<p>Display a complete list of instances in xml format:</p>

<pre> curl --user "user:pass" http://localhost:3001/api/instances?format=xml </pre>

Alternatively and if you prefer you can manually specify the Accept header:

<pre> curl --user "user:pass" -H "Accept: application/xml" http://localhost:3001/api/instances</pre>

<p>Launch an instance. Note that in this example parameters are specified as application/x-www-form-urlencoded through the use of the <strong> -d </strong> flag:</p>

<pre> curl -X POST --user "user:pass" -d "image_id=ami-84db39ed&hwp_id=m1.small&keyname=marios_key"  http://localhost:3001/api/instances?format=xml </pre>

<p>Alternatively, you can use the -F flag to specify the parameters as multipart/form-data:</p>

<pre> curl -X POST --user "user:pass" -F "image_id=ami-84db39ed" -F "hwp_id=m1.small" -F "keyname=marios_key"  http://localhost:3001/api/instances?format=xml </pre>

<p>Launch an instance action - reboot:</p>

<pre> curl -X POST --user "user:pass" http://localhost:3001/api/instances/reboot?format=xml </pre>

<p>Run command on an instance (where available):</p>

<pre> curl -X POST --user "user:pass" -F "cmd=uname -a; ls -l" -F "private_key=`cat /location/of/ssh/keyfile`" http://localhost:3001/api/instances/i-d77cd0ac/run?format=xml </pre>

<h4 id="images">Working with images</h4>

<p>Get the details of a specific image:</p>

<pre> curl --user "user:pass" http://localhost:3001/api/images/ami-3dc06a54?format=xml </pre>

<p>Create an image from an existing instance (where available):</p>

<pre>curl -X POST --user "user:pass" -d "instance_id=i-d77cd0ac&name=mariostestimage" http://localhost:3001/api/images?format=xml </pre>

<p>Delete an image:</p>

<pre>curl -X DELETE --user "user:pass" http://localhost:3001/api/images/ami-3dc06a54?format=xml </pre>

<h4 id="hardware_profiles">Working with hardware profiles</h4>

<p>Get a list of all hardware profiles:</p>

<pre> curl --user "user:pass" http://localhost:3001/api/hardware_profiles?format=xml</pre>

<p>Get the details of a specific hardware profile:</p>

<pre> curl --user "user:pass" http://localhost:3001/api/hardware_profiles/m2.4xlarge?format=xml </pre>

<h4 id="realms">Working with realms</h4>

<p>Get a list of all realms:</p>

<pre> curl --user "user:pass" http://localhost:3001/api/realms?format=xml</pre>

<p>Get the details of a specific realm:</p>

<pre> curl --user "user:pass" http://localhost:3001/api/realms/us-east-1a?format=xml </pre>

<h4 id="realms">Working with keys</h4>

<p>Get a list of all keys:</p>

<pre> curl --user "user:pass" http://localhost:3001/api/keys?format=xml</pre>

<p>Create a new key (where available):</p>

<pre> curl -X POST --user "user:pass" -d "name=mynewkey" http://localhost:3001/api/keys?format=xml </pre>

<p>Import an existing key (where available):</p>

<pre> curl -X POST --user "user:pass" -F "name=mynewkey" -F "public_key=`cat /location/of/public/key/id_rsa.pub`" http://localhost:3001/api/keys?format=xml </pre>

<p>Delete a key:</p>

<pre> curl -X DELETE --user "user:pass" http://localhost:3001/api/keys/mynewkey?format=xml </pre>

<h4 id="firewalls">Working with firewalls</h4>

<p>Get a list of all firewalls:</p>

<pre> curl -v --user "user:pass" http://localhost:3001/api/firewalls?format=xml </pre>

<p>Create a new firewall:</p>

<pre> curl -v -X POST --user "user:pass" -d "name=my_new_firewall&description=a test firewall" http://localhost:3001/api/firewalls?format=xml</pre>

<p>Create a new firewall rule - port 22 tcp,  with one source firewall (group) and 2 IP addresses:</p>

<pre> curl -v -X POST --user "user:pass" -F "protocol=tcp" -F "port_from=22" -F "port_to=22" -F "group1=default" -F "group1owner=821108636519" -F "ip_address1=192.168.1.1/24" -F "ip_address2=65.128.31.27/32" http://localhost:3001/api/firewalls/my_new_firewall/rules</pre>

<p>Delete a firewall rule: </p>

<pre> curl -v -X DELETE --user "user:pass" http://localhost:3001/api/firewalls/marios_test_firewall/821108636519~tcp~22~22~@group,821108636519,default,@address,ipv4,192.168.1.1,24,@address,ipv4,65.128.31.27,32?format=xml </pre>

<p>Delete a firewall:</p>

<pre>curl -v -X DELETE --user "user:pass" http://localhost:3001/api/firewalls/marios_test_firewall?format=xml </pre>

<h4 id="addresses">Working with addresses</h4>

<p>Get a list of all addresses:</p>

<pre> curl -v --user "user:pass" http://localhost:3001/api/addresses?format=xml </pre>

<p>Create a new address:</p>

<pre> curl -v --user "user:pass" -X POST http://localhost:3001/api/addresses?format=xml</pre>


<p>Associate an address with an instance:</p>

<pre> curl -v -X POST --user "user:pass" -d "instance_id=i-d77cd0ac" http://localhost:3001/api/addresses/23.23.176.127/associate?format=xml </pre>


<p>Disassociate an address from an instance:</p>

<pre>curl -v -X POST --user "user:pass" http://localhost:3001/api/addresses/23.23.176.127/disassociate?format=xml  </pre>

<p>Delete an address:</p>

<pre>curl -v -X DELETE --user "user:pass" http://localhost:3001/api/addresses/23.23.176.127?format=xml  </pre>

<h4 id="load_balancers">Working with load balancers</h4>

<p>Get a list of all load balancers:</p>

<pre> curl -v --user "user:pass" http://localhost:3001/api/load_balancers?format=xml </pre>

<p>Create a load balancer:</p>

<pre> curl -v -X POST --user "user:pass" -d "name=webtraffic-balancer&realm_id=us-east-1c&listener_protocol=HTTP&
listener_balancer_port=80&listener_instance_port=3001" http://localhost:3001/api/load_balancers?format=xml </pre>

<p>Register an instance with a load balancer:</p>

<pre> curl -v -X POST --user "user:pass" -d "instance_id=i-4f06b52e" http://localhost:3001/api/load_balancers/webtraffic-balancer/register?format=xml </pre>

<p>Unregister an instance from a load balancer:</p>

<pre> curl -v -X POST --user "user:pass" -d  "instance_id=i-4f06b52e" http://localhost:3001/api/load_balancers/webtraffic-balancer/unregister?format=xml </pre>

<p>Delete a load balancer:</p>

<pre>curl -v --user "user:pass" -X DELETE http://localhost:3001/api/load_balancers/web-traffic-balancer</pre>

<h4 id="buckets">Working with buckets</h4>

<p>Get the details of a bucket:</p>

<pre>curl -v --user "user:pass" http://localhost:3001/api/buckets/my_bucket?format=xml</pre>

<p>Create a new bucket:</p>

<pre>curl -v --user "user:pass" -X POST -d "name=shinynewbucket" http://localhost:3001/api/buckets?format=xml</pre>

<p>Create a new blob, specifying a content-type and some metadata:</p>

<pre>curl -v --user "user:pass" -H "content-type: image/jpg" -H 'X-Deltacloud-Blobmeta-Name:mariosblob' -H 'X-Deltacloud-Blobmeta-Author:me' --upload-file "/some/location/image.jpg" http://localhost:3001/api/buckets/shinynewbucket/newblob?format=xml </pre>

<p> Note that the <strong>--upload-file</strong> parameter above causes cURL to issue a HTTP PUT </p>

<p> Get blob metadata: </p>

<pre> curl -v --user "user:pass" -X HEAD http://localhost:3001/api/buckets/shinynewbucket/newblob</pre>

<p>Note that blob metadata is returned in the HTTP response headers. So the use of the <strong>-v</strong> flag is important here or you will not see the metadata.</p>

<p>Update blob metadata:</p>

<pre>curl -v --user "user:pass" -X POST -H 'X-Deltacloud-Blobmeta-Name:mariosblobV2' -H 'X-Deltacloud-Blobmeta-Version:v2.1.1'  http://localhost:3001/api/buckets/shinynewbucket/newblob?format=xml</pre>

<p>Delete a blob:</p>
<pre>curl -v --user "user:pass" -X DELETE http://localhost:3001/api/buckets/shinynewbucket/newblob?format=xml</pre>

<p>Delete a bucket:</p>
<pre>curl -v --user "user:pass" -X DELETE http://localhost:3001/api/bucket/shinynewbucket</pre>


<h4 id="storage_volumes">Working with storage volumes</h4>

<p>Get a list of all storage volumes:</p>

<pre>curl -v --user "user:pass" http://localhost:3001/api/storage_volumes?format=xml</pre>

<p>Create a new storage volume:</p>

<pre>curl -v --user "user:pass" -X POST -d "capacity=10&realm_id=us-east-1c" http://localhost:3001/api/storage_volumes?format=xml</pre>

<p>Attach a volume to a running instance:</p>

<pre>curl -v --user "user:pass" -X POST -d "instance_id=i-b100b3d0&device=/dev/sdi" http://localhost:3001/api/storage_volumes/vol-0bc0de60/attach?format=xml</pre>

<p>Detach a volume (from whichever instance it is connected to):</p>

<pre>curl -v --user "user:pass" -X POST  http://localhost:3001/api/storage_volumes/vol-0bc0de60/detach?format=xml</pre>

<p>Delete a storage volume:</p>
<pre>curl -v --user "user:pass" -X DELETE http://localhost:3001/api/storage_volumes/vol-0bc0de60?format=xml</pre>

<h4 id="storage_snapshots">Working with storage snapshots</h4>

<p>Get details about a specific storage snapshot:</p>
<pre>curl -v --user "user:pass" http://localhost:3001/api/storage_snapshots/snap-45b8d024?format=xml</pre>

<p>Create a new storage snapshot:</p>
<pre>curl -v --user "user:pass" -X POST -d "volume_id=vol-99fbe5f2" http://localhost:3001/api/storage_snapshots?format=xml</pre>

<p>Delete a storage snapshot:</p>
<pre>curl -v --user "user:pass" -X DELETE http://localhost:3001/api/storage_snapshots/snap-dda6cebc?format=xml</pre>

