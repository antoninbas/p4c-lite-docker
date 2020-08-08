#include <core.p4>
#include <v1model.p4>

struct metadata {
}

struct headers {
}

parser ParserImpl(packet_in packet, out headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {
    state start {
        transition accept;
    }
}

control IngressImpl(inout headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {
    apply {
        standard_metadata.egress_spec = standard_metadata.ingress_port;
    }
}

control EgressImpl(inout headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {
    apply { }
}

control DeparserImpl(packet_out packet, in headers hdr) {
    apply {
        packet.emit(hdr);
    }
}

control VerifyChecksumImpl(inout headers hdr, inout metadata meta) {
    apply { }
}

control ComputeChecksumImpl(inout headers hdr, inout metadata meta) {
    apply { }
}

V1Switch(p = ParserImpl(),
         ig = IngressImpl(),
         vr = VerifyChecksumImpl(),
         eg = EgressImpl(),
         ck = ComputeChecksumImpl(),
         dep = DeparserImpl()) main;
