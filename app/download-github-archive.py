import os

if __name__ == "__main__":
    months = [str(num).zfill(2) for num in range(4, 7)]
    days = [str(num).zfill(2) for num in range(1,32)]
    hours = [str(num) for num in range(0, 24)]

    for month in months:
        for day in days:
            for hour in hours:
                filename = "2013-%s-%s-%s.json.gz" % (month, day, hour)
                if os.path.exists(filename):
                    print "%s exists." % (filename)
                    continue
                url = "http://data.githubarchive.org/%s" % filename
                cmd = "wget %s" % (url)
                print "Running %s" % (cmd)
                os.system(cmd)
            
    
    


