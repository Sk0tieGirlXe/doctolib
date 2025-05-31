# Dockerfile to create image with cron services
FROM python:3.13-bookworm

#Install Cron
RUN apt-get update && apt-get -y install cron nano

# Add the cron job
RUN echo "*/5 7-23 * * * python3 /root/notifyDoctolibDoctorsAppointment.py  >> /var/log/cron.log 2>&1" > /etc/cron.d/bergdoctorlib \
	&& chmod 0644 /etc/cron.d/bergdoctorlib \
        && crontab /etc/cron.d/bergdoctorlib \
	&& touch /var/log/cron.log

# Add the script to the Docker Image
ADD notifyDoctolibDoctorsAppointment.py /root/notifyDoctolibDoctorsAppointment.py

# Give execution rights on the cron scripts
RUN chmod 0644 /root/notifyDoctolibDoctorsAppointment.py

# Run the command on container startup
CMD cron && tail -f /var/log/cron.log
