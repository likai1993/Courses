/*
 *  gen_utils.cc
 *
 *  This file is part of TinyHttpServer
 *
 *  TinyHttpServer is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  TinyHttpServer is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with TinyHttpServer; if not, write to the Free Software
 *  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  US
 *
 *  Author:	Antonino Calderone, <acaldmail@gmail.com>
 *  CO-Author:	Kai Li, <recarelee@gmail.com>
 *
 *  This work was updated and extended by Kai Li, for the purpose of demostrating
 *  the final project of CSE775 - Distributed Object.
 */

/// \file gen_utils.cc
/// \brief Collection of general purpose utilities


// -----------------------------------------------------------------------------

#include "gen_utils.h"
#include "os_dep.h"
#include <openssl/md5.h>
#include <stdio.h>

// -----------------------------------------------------------------------------


void gen_utils::convert_duration_in_timeval(const timeout_t& d, timeval& tv)
{
    std::chrono::microseconds usec
        = std::chrono::duration_cast<std::chrono::microseconds>(d);

    if (usec <= std::chrono::microseconds(0)) {
        tv.tv_sec = tv.tv_usec = 0;
    } else {
        tv.tv_sec = static_cast<long>(usec.count() / 1000000LL);
        tv.tv_usec = static_cast<long>(usec.count() % 1000000LL);
    }
}


// -----------------------------------------------------------------------------


bool gen_utils::compare_time(time_t& t1, time_t& t2)
{
	
   double seconds = difftime(t2,t1);
   printf("time diff: %f\n", seconds);
   return seconds >= 0 ? true : false;

}


// -----------------------------------------------------------------------------


void gen_utils::get_path_by_md5sum(std::string& str, std::string& path)
{
    unsigned char temp_hash[MD5_DIGEST_LENGTH];
    printf("%s\n",str.c_str());
    MD5((unsigned char*)str.c_str(), str.length(), temp_hash);

    char c_path_prefix[10];
    /* 
    for(int i=0; i <MD5_DIGEST_LENGTH; i++) {
            printf("%02x",temp_hash[i]);
    }
    printf("\n");
    */

    /* get the first and second heximal character from temp_hash[0] */
    sprintf(c_path_prefix,"%02x",temp_hash[0]);
    std::string path_prefix(c_path_prefix);
    path = "/" + path_prefix.substr(0,1) + "/" + path_prefix.substr(1,1);

    /* get the third character from temp_hash[1] */
    sprintf(c_path_prefix,"%02x",temp_hash[1]);
    std::string path_prefix1(c_path_prefix); 

    /* construct the searching path */
    path += path_prefix1.substr(0,1) + str;
}



// -----------------------------------------------------------------------------


void gen_utils::str2time(std::string& time, time_t& t)
{

    const char * c = time.c_str();
 
    struct tm tm;

    if (strptime(c, " %a %b  %d %H:%M:%S %Y", &tm) == NULL)
	printf("[Error!] Convert time from string to seconds\n");

    tm.tm_isdst = -1;     /* Not set by strptime(); tells mktime()
                          to determine whether daylight saving time
                          is in effect */
    t = mktime(&tm);
    if (t == -1)
        /* Handle error */;
    printf("seconds since the Epoch: %ld\n", (long) t);
}



// -----------------------------------------------------------------------------


void gen_utils::get_local_time(std::string& local_time)
{
    time_t ltime;
    ltime = ::time(NULL); // get current calendar time
    local_time = ::asctime(::localtime(&ltime));
    gen_utils::remove_last_ch_if(local_time, '\n');
}


// -----------------------------------------------------------------------------


void gen_utils::remove_last_ch_if(std::string& s, char c)
{
    while (!s.empty() && s.c_str()[s.size() - 1] == c)
        s = s.substr(0, s.size() - 1);
}


// -----------------------------------------------------------------------------


bool gen_utils::file_stat(const std::string& filename, std::string& date_time,
    std::string& ext, size_t& fsize)
{
    struct stat rstat = { 0 };
    int ret = stat(filename.c_str(), &rstat);

    if (ret >= 0) {
        date_time = ctime(&rstat.st_mtime);
        fsize = rstat.st_size;

        std::string::size_type pos = filename.rfind('.');
        ext = pos != std::string::npos
            ? filename.substr(pos, filename.size() - pos)
            : ".";

        gen_utils::remove_last_ch_if(date_time, '\n');

        return true;
    }

    return false;
}


// ---------------------------------------------------------------------------


// The regex library still seems to be mostly not implemented in libstdc++

#ifndef _USE_REGEX_

bool gen_utils::split_line_in_tokens(const std::string& line,
    std::vector<std::string>& tokens, const std::string& sep)
{
    if (line.empty() || line.size() < sep.size())
        return false;

    std::string subline = line;

    while (!subline.empty()) {
        size_t pos = subline.find(sep);

        if (pos == std::string::npos) {
            tokens.push_back(subline);
            return true;
        }

        tokens.push_back(subline.substr(0, pos));

        size_t off = pos + sep.size();

        subline = subline.substr(off, subline.size() - off);
    }

    return true;
}

#else

// implemented using regex

bool gen_utils::split_line_in_tokens(const std::string& line,
    std::vector<std::string>& tokens, const std::string& sep)
{
    std::regex regexp(sep);
    std::sregex_token_iterator i(line.begin(), line.end(), regexp, -1), LAST;

    try {
        while (i != LAST) {
            if (i->first != line.end())
                tokens.push_back(i->str());
            ++i;
        }
    } catch (const std::regex_error&) {
        return false;
    }
    return true;
}


#endif


// ---------------------------------------------------------------------------
