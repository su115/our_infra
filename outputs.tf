output "EXTERNAL_IP" {
 value = google_compute_instance.bastion[0].network_interface[0].access_config[0].nat_ip
}
output "BASTION_IP" {
 value = google_compute_instance.bastion[0].network_interface[0].network_ip
 }
output "MASTER_IP_1" {
 value = google_compute_instance.master[0].network_interface[0].network_ip
}
# output "MASTER_IP_2" {
#  value = google_compute_instance.master[1].network_interface[0].network_ip
# }
output "SLAVE_1" {
 value = google_compute_instance.slave[0].network_interface[0].network_ip
}
output "SLAVE_2" {
 value = google_compute_instance.slave[1].network_interface[0].network_ip
}
#output "DB" {
# value = google_compute_instance.db[0].network_interface[0].network_ip
#} 
