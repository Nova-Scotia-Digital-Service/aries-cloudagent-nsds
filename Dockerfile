FROM harbor.novascotia.ca/cts/devops-cicd:latest as builder
#FROM ubuntu:bionic as builder
ARG CI_JOB_TOKEN=${CI_JOB_TOKEN}
RUN curl -L --output libindystrgpostgres.so --header "JOB-TOKEN: $CI_JOB_TOKEN" https://git.novascotia.ca/api/v4/projects/14/packages/generic/indy-sdk-postgres/1.0.0/libindystrgpostgres.so


FROM bcgovimages/aries-cloudagent:py36-1.15-1_0.6.0
COPY --from=builder --chown=indy:indy libindystrgpostgres.so /home/indy/lib
