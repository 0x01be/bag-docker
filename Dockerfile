FROM 0x01be/bag:build as build

FROM alpine

COPY --from=build /opt/bag/ /opt/bag/

